defmodule Contract.Entity.Player do
  alias Contract.Entity.Card
  alias Contract.Entity.Player
  defstruct [:type, :id, :name, :hand, :kpi, :score]

  @type t :: %__MODULE__{
          type: :freelancer | :staff,
          id: UXID.uxid_string(),
          name: String.t(),
          hand: list(Card.t()),
          kpi: map(),
          score: integer()
        }

  def new(name, type) do
    %Player{
      type: type,
      id: UXID.generate!(prefix: "player", size: :small),
      name: name,
      hand: [],
      kpi: nil,
      score: 0
    }
  end

  def put_hand(%Player{} = player, hand) do
    %{player | hand: hand}
  end

  def remove_from_hand(%Player{hand: hand} = player, card_id) when is_bitstring(card_id) do
    case Enum.find_index(hand, &(&1.id == card_id)) do
      nil -> player
      ix -> %{player | hand: List.delete_at(hand, ix)}
    end
  end

  def add_to_hand(%Player{} = player, %Card{} = card) do
    %{player | hand: player.hand ++ [card]}
  end

  def freelancer?(%Player{} = player) do
    player.type == :freelancer
  end

  def staff?(%Player{} = player) do
    player.type == :staff
  end
end

defmodule Contract.Entity.PlayerMap do
  alias Contract.Entity.Player
  alias Contract.Entity.Card

  def by_name(players, name) do
    Map.keys(players)
    |> Enum.map(&players[&1])
    |> Enum.filter(&(&1.name == name))
    |> hd
  end

  # def increment_score

  def card_in_hand(player, shape, property) do
    player.hand
    |> Enum.filter(&(&1.shape == shape && &1.property == property))
    |> hd
  end

  def card_in_hand(player, card_id) when is_bitstring(card_id) do
    player.hand
    |> Enum.filter(&(&1.id == card_id))
    |> hd
  end

  def add_to_hand(players, player_id, %Card{} = card) do
    player = players[player_id]
    player = Player.add_to_hand(player, card)
    Map.put(players, player_id, player)
  end

  def remove_from_hand(players, player_id, %Card{} = card) do
    player = players[player_id]
    player = Player.remove_from_hand(player, card.id)
    Map.put(players, player_id, player)
  end
end
