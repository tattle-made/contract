defmodule Contract.Entity.RoundTest do
  alias Contract.Entity.Client
  alias Contract.Entity.Round.RoundNumberMaxExceeded
  alias Contract.Entity.Round
  use ExUnit.Case

  describe "entity" do
    test "new/1" do
      round_a = Round.new(1) |> IO.inspect()
      assert %Client{} = round_a.clients

      round_b = Round.new(3) |> IO.inspect()
      assert [%Client{} = hd | tail] = round_b.clients

      assert_raise RoundNumberMaxExceeded, fn ->
        Round.new(6)
      end
    end
  end
end
