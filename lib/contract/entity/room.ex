defmodule Contract.Entity.Room do
  defstruct [:state, :name, :password, :players, :roles]

  @type role :: :freelancer | :staff
  @type t :: %__MODULE__{
          roles: %{freelancer: list(), staff: list()}
        }
end

defmodule Contract.Entity.Room.IncorrectPasswordException do
  defexception message: "Incorrect Password"
end
