defmodule Contract.Design.RoomGen do
  alias Contract.Factory
  use GenServer

  @registry Contract.Design.Registry

  def start_link(room_id) do
    GenServer.start_link(__MODULE__, room_id, name: {:via, Registry, {@registry, room_id}})
  end

  @impl true
  def init(room_id) do
    state = Factory.make_design_room(room_id)

    {:ok, state}
  end

  @impl true
  def handle_cast({:open_trade}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    IO.inspect("msg in genserver #{msg}")
    {:noreply, state}
  end
end

defmodule Contract.Design.Room.RoomReserved do
  defstruct name: nil, id: nil

  @type t :: %__MODULE__{
          id: UXID.uxid_string(),
          name: String.t()
        }
end
