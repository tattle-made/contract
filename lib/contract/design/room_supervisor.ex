defmodule Contract.Design.RoomSupervisor do
  @moduledoc """
  Supervisor for Design Room.

  This architecture is heavily borrowed from [here](https://dashbit.co/blog/homemade-analytics-with-ecto-and-elixir).
  Rooms need to manage mutable state of the game, hence they are wrapped in a `GenServer`. These genservers are then supervised by a Dynamic Supervisor, which is managed by this Supervisor. This supervisor is started by the application and is part of its supervision tree.

  ## Usage :
  ```elixir
  alias Contract.Design.RoomSupervisor
  room = RoomSupervisor.reserve()
  {:ok, room_gen} = RoomSupervisor.room_gen!(room.id)
  send(room_gen, "ok")
  :sys.get_state(room_gen)
  ```
  """
  alias Contract.Design.Room.RoomReserved

  use Supervisor

  @room_gen Contract.Design.RoomGen
  @registry Contract.Design.Registry
  @supervisor Contract.Design.RoomDynamicSupervisor

  @doc """
  Used by `Application`
  """
  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      {Registry, keys: :unique, name: @registry},
      {DynamicSupervisor, name: @supervisor, strategy: :one_for_one}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @doc """
  Registers and creates a new Room.

  This ensures there is only one room registered with a path.
  """
  def reserve(room_id) do
    _pid =
      case DynamicSupervisor.start_child(@supervisor, {@room_gen, room_id}) do
        {:ok, pid} -> pid
        {:error, {:already_started, pid}} -> pid
      end

    %RoomReserved{id: room_id}
  end

  @doc """
  Returns the GenServer associated with a room name
  """
  def room_gen!(room_id) do
    case Registry.lookup(@registry, room_id) do
      [{pid, _}] -> {:ok, pid}
      _ -> {:error, :not_found}
    end
  end

  def room_gen(room_id) do
    case room_gen!(room_id) do
      {:ok, pid} ->
        pid

      {:error, :not_found} ->
        room_reserved = reserve(room_id)
        {:ok, pid} = room_gen!(room_reserved.id)
        pid
    end
  end
end
