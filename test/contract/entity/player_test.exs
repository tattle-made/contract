defmodule Contract.Entity.PlayerTest do
  alias Contract.Entity.Card
  alias Contract.Entity.Player
  use ExUnit.Case

  describe "entity" do
    test "hand management" do
      player = Player.new(name: "adhiraj", type: :staff)
      assert length(player.hand) == 0

      card = %Card{id: "card_acxasdf", shape: :star, property: :team_memo}
      player = Player.add_to_hand(player, card)
      assert length(player.hand) == 1

      card = %Card{id: "card_btxasfg", shape: :comet, property: :project_estimate}
      player = Player.add_to_hand(player, card)
      assert length(player.hand) == 2

      assert [
               %Contract.Entity.Card{
                 id: "card_acxasdf",
                 shape: :star,
                 property: :team_memo
               },
               %Contract.Entity.Card{
                 id: "card_btxasfg",
                 shape: :comet,
                 property: :project_estimate
               }
             ] = player.hand

      player = Player.remove_from_hand(player, "card_btxasfg")

      assert [
               %Contract.Entity.Card{
                 id: "card_acxasdf",
                 shape: :star,
                 property: :team_memo
               }
             ] = player.hand
    end
  end
end
