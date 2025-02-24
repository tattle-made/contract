defmodule Contract.Factory do
  require IEx
  alias Contract.Shared.NameGenerator
  alias Contract.Entity.Room, as: EntityRoom
  alias Contract.Entity.Round, as: EntityRound
  alias Contract.Design.DesignRoom
  alias Contract.Entity.State, as: EntityState
  alias Contract.Entity.Card, as: EntityCard
  alias Contract.Canon.Card

  alias Contract.Design.Player
  alias Contract.Design.Client
  alias Contract.Design.Round
  alias Contract.Design.Room
  alias Contract.Entity.Player, as: EntityPlayer

  def make_design_room(room_id, opts \\ []) do
    _player_count = Keyword.get(opts, :count, 4)

    %EntityState{
      room: %EntityRoom{
        id: room_id,
        state: :waiting,
        name: NameGenerator.name(),
        password: "kabootar",
        players: [],
        player_names: %{},
        roles: %{}
      },
      round: %EntityRound{},
      players: %{},
      trades: [],
      reports: %{}
    }
    |> EntityState.join_room("adhiraj", "kabootar")
    |> EntityState.join_room("aman", "kabootar")
    |> EntityState.join_room("farah", "kabootar")
    |> EntityState.join_room("krys", "kabootar")
    |> EntityState.start_game()
    |> EntityState.first_round()
  end

  def make_random_card_entity() do
    card = Card.random()

    %EntityCard{
      id: card.id,
      shape: card.shape,
      property: card.property
    }
  end

  def make_card_entity_from(%Card{} = canon_card) do
    %EntityCard{
      id: canon_card.id,
      shape: canon_card.shape,
      property: canon_card.property
    }
  end

  @doc """
  Create a representation of the Game UI from the Game's state
  """
  def make_design_page(%EntityState{} = state) do
    state_room = state.room
    state_round = state.round
    state_players = state.players
    state_trades = state.trades
    # state_logs = state.logs

    room = %Room{
      id: state_room.id,
      name: state_room.name
    }

    round = %Round{
      number: state_round.count
    }

    clients =
      Enum.map(state_round.clients, fn client ->
        %Client{
          id: client.id,
          name: client.name,
          requirements: client.requirements
        }
      end)

    staff_players =
      state_players
      |> Enum.map(&elem(&1, 1))
      |> Enum.filter(&EntityPlayer.staff?/1)
      |> Enum.map(fn player ->
        # IEx.pry()

        other_staff =
          state_room.players
          |> Enum.filter(&(&1 != player.id))
          |> Enum.map(&state_players[&1])
          |> Enum.map(&EntityPlayer.preview/1)

        pending_trades =
          state_trades
          |> Enum.filter(&(&1.to == player.id))

        %Player{
          id: player.id,
          name: player.name,
          type: player.type,
          score: player.score,
          hand: player.hand,
          other_staff: other_staff,
          pending_trades: pending_trades
        }
      end)

    freelance_players =
      state_players
      |> Enum.map(&elem(&1, 1))
      |> Enum.filter(&EntityPlayer.freelancer?/1)
      |> Enum.map(fn player ->
        other_staff =
          state_room.roles.staff
          |> Enum.filter(&(&1 != player.id))
          |> Enum.map(&state_players[&1])
          |> Enum.map(&EntityPlayer.preview/1)

        other_freelancer =
          state_room.roles.freelancer
          |> Enum.filter(&(&1 != player.id))
          |> Enum.map(&state_players[&1])
          |> Enum.map(&EntityPlayer.preview/1)

        pending_trades =
          state_trades
          |> Enum.filter(&(&1.to == player.id))

        %Player{
          id: player.id,
          type: player.type,
          name: player.name,
          score: player.score,
          hand: player.hand,
          other_staff: other_staff,
          other_freelancers: other_freelancer,
          pending_trades: pending_trades
        }
      end)

    %DesignRoom{
      room: room,
      round: round,
      clients: clients,
      staff_players: staff_players,
      freelance_players: freelance_players
    }
  end
end
