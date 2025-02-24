defmodule Contract.Entity.Room do
  alias Contract.Entity.Player
  defstruct [:id, :state, :name, :password, :players, :player_names, :roles]

  @type role :: :freelancer | :staff
  @type t :: %__MODULE__{
          roles: %{freelancer: list(), staff: list(Player.t())}
        }
end

defmodule Contract.Entity.Room.IncorrectPasswordException do
  defexception message: "Incorrect Password"
end
