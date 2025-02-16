defmodule Contract.Entity.StateTest do
  alias Contract.StateFixtures
  use ExUnit.Case

  describe "struct transformations" do
    setup do
      state = StateFixtures.four_player_game()

      %{state: state}
    end

    test "one round game", %{state: state} do
      IO.inspect(state)
    end
  end
end
