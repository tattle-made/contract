defmodule Contract.Design.RoomGen do
  alias Contract.Entity.Reducer
  alias Contract.Design.Action
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

  def state(pid) do
    :sys.get_state(pid)
  end

  @impl true
  def handle_call(%Action{type: :open_trade} = action, _from, state) do
    new_state = Reducer.reduce(state, action)
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call(%Action{type: :accept_trade} = action, _from, state) do
    new_state = Reducer.reduce(state, action)
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call(%Action{type: :secret_trade} = action, _from, state) do
    new_state = Reducer.reduce(state, action)
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call(%Action{type: :submit_to_client} = action, _from, state) do
    new_state = Reducer.reduce(state, action)
    {:reply, new_state, new_state}
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
