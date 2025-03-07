defmodule Contract.Entity.State do
  require IEx
  alias Contract.Entity.Report
  alias Contract.Entity.State
  alias Contract.Entity.PlayerMap
  alias Contract.Factory
  alias Contract.Entity.Trade.NoOpenTrade
  alias Contract.Entity.Trade
  alias Contract.Entity.Card
  alias Contract.Entity.Room.IncorrectPasswordException
  alias Contract.Entity.Player
  alias Contract.Entity.Round
  alias Contract.Entity.State

  defstruct [:room, :round, :players, :trades, :reports, :logs]

  def join_room(%State{} = state, player_name, password) do
    player = Player.new(name: player_name)

    case state.room.password == password do
      true ->
        current_players = state.room.players

        %{
          state
          | room: %{
              state.room
              | players: current_players ++ [player.id],
                player_names: Map.put(state.room.player_names, player.id, player.name)
            }
        }

      false ->
        raise IncorrectPasswordException
    end
  end

  def start_game(%State{} = state) do
    state = %{state | room: %{state.room | state: :running}}
    room = state.room

    freelancer_count = (length(room.players) / 3) |> round
    {freelancers, staff} = room.players |> Enum.shuffle() |> Enum.split(freelancer_count)

    state = %{state | room: %{room | roles: %{freelancer: freelancers, staff: staff}}}

    player_names = state.room.player_names

    freelancer_players =
      freelancers |> Enum.map(&Player.new(id: &1, name: player_names[&1], type: :freelancer))

    staff_players = staff |> Enum.map(&Player.new(id: &1, name: player_names[&1], type: :staff))

    all =
      (freelancer_players ++ staff_players)
      |> Enum.reduce(%{}, fn x, acc ->
        hand = for _ <- 1..3, do: Factory.make_random_card_entity()
        player = Player.put_hand(x, hand)
        Map.put(acc, player.id, player)
      end)

    %{state | players: all, room: %{state.room | player_names: nil}}
  end

  def first_round(%State{} = state) do
    %{state | round: Round.new(2, &Factory.make_random_card_entity/0)}
  end

  def can_submit_to_client(%State{} = state, cards, client_id) do
    client = Round.client(state.round, client_id)
    client_requirements = client.requirements |> Enum.map(&Card.value/1)

    is_subset = MapSet.subset?(MapSet.new(client_requirements), MapSet.new(cards))
    is_same_length = length(client_requirements) == length(cards)

    is_subset && is_same_length
  end

  def submit_to_client(%State{} = state, player_id, cards, client_id) do
    # update player score

    # remove cards from player's hands
    player = state.players[player_id]

    players =
      Enum.reduce(cards, state.players, fn card, players ->
        PlayerMap.remove_from_hand(players, player.id, card)
      end)

    # remove client from round
    client = state.round.clients[client_id]
    clients = state.round.clients |> List.delete(client)
    round = %{state.round | clients: clients}

    %{state | players: players, round: round}
  end

  def add_report(%State{} = state, from_id, against_id) do
    player = state.players[against_id]
    is_freelancer = Player.freelancer?(player)

    total_players = length(Map.keys(state.players))

    report =
      case state.reports[against_id] do
        nil -> %Report{}
        report -> report
      end

    # todo add complaints

    report = %{report | by: report.by ++ [from_id], valid: is_freelancer}

    total_complaints = length(report.by)

    report =
      if total_complaints > total_players / 2,
        do: %{report | can_remove: true},
        else: %{report | can_remove: false}

    %{state | reports: Map.put(state.reports, against_id, report)}
  end

  def maybe_punish_freelancer(%State{} = state) do
  end
end
