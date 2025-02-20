defmodule Contract.Entity.RoundTest do
  alias Contract.Factory
  alias Contract.Entity.Client
  alias Contract.Entity.Round.RoundNumberMaxExceeded
  alias Contract.Entity.Round
  use ExUnit.Case

  describe "entity" do
    test "new/1" do
      round_a = Round.new(1, &Factory.make_random_card_entity/0)
      assert [%Client{}] = round_a.clients

      round_b = Round.new(3, &Factory.make_random_card_entity/0)
      assert [%Client{} = hd | tail] = round_b.clients

      assert_raise RoundNumberMaxExceeded, fn ->
        Round.new(6, &Factory.make_random_card_entity/0)
      end
    end
  end
end
