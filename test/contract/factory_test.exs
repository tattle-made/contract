defmodule Contract.FactoryTest do
  alias Contract.Entity.PlayerMap
  alias Contract.Factory
  import Contract.StateFixtures
  use ExUnit.Case

  @tag timeout: :infinity
  test "make_design_room/1" do
    :rand.seed(:exsss, {1, 8, 12})

    state = Factory.make_design_room("room_bcn23dn")
    IO.inspect(state)
  end

  test "make_design_page/1" do
    :rand.seed(:exsss, {1, 8, 12})

    state =
      new_game()
      |> join_room("adhiraj", "kabootar")
      |> join_room("aman", "kabootar")
      |> join_room("farah", "kabootar")
      |> join_room("krys", "kabootar")
      |> start_game()
      |> first_round()

    farah = PlayerMap.by_name(state.players, "farah")
    krys = PlayerMap.by_name(state.players, "krys")

    card = PlayerMap.card_in_hand(farah, :crescent_moon, :creative_brief)
    state = state |> open_trade(card.id, farah.id, krys.id)

    room_state = Factory.make_design_page(state)

    # IEx.pry()
  end
end
