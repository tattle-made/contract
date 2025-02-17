defmodule Contract.StateFixtures do
  require IEx
  alias Contract.Entity.PlayerMap
  alias Contract.Factory
  alias Contract.Entity.Trade.NoOpenTrade
  alias Contract.Entity.Trade
  alias Contract.Canon.Card
  alias Contract.Entity.Room.IncorrectPasswordException
  alias Contract.Entity.Player
  alias Contract.Entity.Round
  alias Contract.Entity.Room
  alias Contract.Entity.State

  def four_player_game() do
    %State{
      room: %Room{
        state: :waiting,
        name: "happy-eagle-23",
        password: "kabootar",
        players: [],
        roles: %{}
      },
      round: %Round{},
      players: %{},
      trades: []
    }
  end

  def join_room(%State{} = state, player_name, password) do
    case state.room.password == password do
      true ->
        current_players = state.room.players
        %{state | room: %{state.room | players: current_players ++ [player_name]}}

      false ->
        raise IncorrectPasswordException
    end
  end

  def start_game(%State{} = state) do
    state = %{state | room: %{state.room | state: :running}}
    room = state.room

    freelancer_count = Integer.floor_div(length(room.players), 4)
    {freelancers, staff} = room.players |> Enum.shuffle() |> Enum.split(freelancer_count)

    state = %{state | room: %{room | roles: %{freelancer: freelancers, staff: staff}}}

    freelancer_players = freelancers |> Enum.map(&Player.new(&1, :freelancer))
    staff_players = staff |> Enum.map(&Player.new(&1, :staff))

    all =
      (freelancer_players ++ staff_players)
      |> Enum.reduce(%{}, fn x, acc ->
        hand = for _ <- 1..3, do: Factory.make_random_card_entity()
        player = Player.put_hand(x, hand)
        Map.put(acc, player.id, player)
      end)

    %{state | players: all}
  end

  def first_round(%State{} = state) do
    %{state | round: Round.new(1)}
  end

  def open_trade(%State{} = state, card_id, from, to) do
    trade = %Trade{type: :open, card_id: card_id, from: from, to: to}
    %{state | trades: state.trades ++ [trade]}
  end

  def accept_trade(%State{} = state, card_id, from, to) do
    case Enum.find(state.trades, nil, &(&1.from == to && &1.to == from)) do
      nil ->
        raise NoOpenTrade

      %Trade{} = open_trade ->
        #  delete open trade
        trades =
          state.trades
          |> List.delete(open_trade)

        # swap cards in player's hands
        players = state.players

        open_player = players[open_trade.from]
        open_card = PlayerMap.card_in_hand(open_player, open_trade.card_id)
        accepting_player = players[from]
        accepting_card = PlayerMap.card_in_hand(accepting_player, card_id)

        players =
          players
          |> PlayerMap.remove_from_hand(open_player.id, open_card)
          |> PlayerMap.add_to_hand(open_player.id, accepting_card)
          |> PlayerMap.remove_from_hand(accepting_player.id, accepting_card)
          |> PlayerMap.add_to_hand(accepting_player.id, open_card)

        %{state | players: players, trades: trades}
    end
  end
end
