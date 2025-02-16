defmodule Contract.StateFixtures do
  alias Contract.Entity.Player
  alias Contract.Entity.Round
  alias Contract.Entity.Room
  alias Contract.Entity.State

  def four_player_game() do
    %State{
      room: %Room{},
      round: %Round{},
      players: %{
        player_abc: %Player{},
        player_def: %Player{},
        player_ghi: %Player{},
        player_jkl: %Player{}
      },
      trades: %{}
    }
  end
end
