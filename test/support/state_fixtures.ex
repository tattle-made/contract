defmodule Contract.StateFixtures do
  alias Contract.Entity.Client
  alias Contract.Entity.PlayerMap
  alias Contract.Factory
  alias Contract.Entity.Trade.NoOpenTrade
  alias Contract.Entity.Trade
  alias Contract.Entity.Card
  alias Contract.Entity.Room.IncorrectPasswordException
  alias Contract.Entity.Player
  alias Contract.Entity.Round
  alias Contract.Entity.Room
  alias Contract.Entity.State

  def new_game() do
    %State{
      room: %Room{
        state: :waiting,
        name: "happy-eagle-23",
        password: "kabootar",
        players: [],
        player_names: %{},
        roles: %{}
      },
      round: %Round{},
      players: %{},
      trades: [],
      reports: %{}
    }
  end

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

    freelancer_count = Integer.floor_div(length(room.players), 4)
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
    %{state | round: Round.new(1, &Factory.make_random_card_entity/0)}
  end

  def open_trade(%State{} = state, card_id, from, to) do
    card = state.players[from].hand |> Enum.find(&(&1.id == card_id))

    trade = %Trade{type: :open, card: card, from: from, to: to}
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
        open_card = PlayerMap.card_in_hand(open_player, open_trade.card.id)
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
      Enum.reduce(cards, state.players, fn card_id, players ->
        card = PlayerMap.card_in_hand(players[player.id], card_id)
        PlayerMap.remove_from_hand(players, player.id, card)
      end)

    # remove client from round
    client = state.round.clients[client_id]
    clients = state.round.clients |> List.delete(client)
    round = %{state.round | clients: clients}

    %{state | players: players, round: round}
  end

  def add_report(%State{} = state, player_id) do
    player = state.players[player_id]

    case Player.freelancer?(player) do
      true ->
        total_players = length(state.players)
        report = state.reports[player_id]
        # todo add complaints
        report = %{report | by: report.by ++ [player_id]}

        total_complaints = length(report.by)

        report =
          if total_complaints > total_players / 2, do: %{report | can_remove: true}, else: report

        # report = %{state.report | reports: %{} }

        %{state | reports: report}
    end
  end

  def maybe_punish_freelancer(%State{} = state) do
  end
end
