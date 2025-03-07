defmodule Contract.Entity.StateTest do
  alias Contract.Entity.Report
  alias Contract.Entity.Player
  alias Contract.Entity.State
  alias Contract.Entity.PlayerMap
  alias Contract.Entity.Room.IncorrectPasswordException
  alias Contract.StateFixtures
  use ExUnit.Case

  describe "state changes" do
    import Contract.StateFixtures

    setup do
      :rand.seed(:exsss, {1, 8, 12})
      state = StateFixtures.new_game()

      %{state: state}
    end

    test "one round game happy path", %{state: state} do
      state =
        state
        |> join_room("adhiraj", "kabootar")
        |> join_room("aman", "kabootar")
        |> join_room("farah", "kabootar")
        |> join_room("krys", "kabootar")

      assert_raise IncorrectPasswordException, fn ->
        state |> join_room("denny", "sparrow")
      end

      assert Map.keys(state.players) |> length() == 0

      state =
        state
        |> start_game()

      assert Map.keys(state.players) |> length() == 4

      state = state |> first_round()

      adhiraj = PlayerMap.by_name(state.players, "adhiraj")
      aman = PlayerMap.by_name(state.players, "aman")
      krys = PlayerMap.by_name(state.players, "krys")
      farah = PlayerMap.by_name(state.players, "farah")

      # open trade from krys to farah of a card(star, expense_report)
      card = PlayerMap.card_in_hand(krys, :star, :expense_report)
      state = state |> open_trade(card.id, krys.id, farah.id)

      card_b = PlayerMap.card_in_hand(adhiraj, :asteroid, :expense_report)
      state = state |> open_trade(card_b.id, adhiraj.id, farah.id)

      card_farah = PlayerMap.card_in_hand(farah, :crescent_moon, :creative_brief)
      state = state |> accept_trade(card_farah.id, farah.id, krys.id)

      krys = PlayerMap.by_name(state.players, "krys")
      farah = PlayerMap.by_name(state.players, "farah")
      assert card in farah.hand
      assert card_farah in krys.hand

      # cards =
      #   [PlayerMap.card_in_hand(krys, "card_01JMCAWVDZM731")]
      #   |> Enum.map(&Card.value/1)

      # IEx.pry()
      # secret swap

      # submit to client

      # report HR
    end
  end

  @tag timeout: :infinity
  describe "temp" do
    import Contract.StateFixtures

    setup do
      :rand.seed(:exsss, {1, 8, 12})
      state = StateFixtures.new_game()

      %{state: state}
    end

    test "one round game happy path", %{state: state} do
      state =
        state
        |> join_room("adhiraj", "kabootar")
        |> join_room("aman", "kabootar")
        |> join_room("farah", "kabootar")
        |> join_room("krys", "kabootar")

      # IEx.pry()
    end
  end

  @tag timeout: :infinity
  describe "report player" do
    setup do
      state = %State{
        players: %{
          "player_abc" => %Player{id: "player_abc", name: "adhiraj", type: :freelancer},
          "player_def" => %Player{id: "player_def", name: "aman", type: :freelancer},
          "player_ghi" => %Player{id: "player_ghi", name: "farah", type: :staff},
          "player_jkl" => %Player{id: "player_jkl", name: "krys", type: :staff},
          "player_mno" => %Player{id: "player_mno", name: "denny", type: :staff}
        },
        reports: %{}
      }

      %{state: state}
    end

    test "valid report", %{state: state} do
      state =
        state
        |> State.add_report("player_ghi", "player_abc")

      report = state.reports["player_abc"]
      assert report.can_remove == false

      state =
        state
        |> State.add_report("player_jkl", "player_abc")
        |> State.add_report("player_mno", "player_abc")

      report = state.reports["player_abc"]

      assert length(report.by) == 3
      assert report.can_remove == true
    end

    test "invalid report" do
    end
  end
end
