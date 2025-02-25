defmodule ContractWeb.DesignLive.FourPlayer do
  import ContractWeb.Molecules
  require IEx
  alias Contract.Entity.Reducer
  alias Contract.Design.Action
  alias Contract.Design.RoomGen
  alias Contract.Factory
  alias Contract.Design.RoomSupervisor

  use ContractWeb, :live_view
  use ContractWeb, :html

  def mount(_params, session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"room_id" => room_id}, _uri, socket) do
    pid = RoomSupervisor.room_gen(room_id)
    game_state = RoomGen.state(pid)
    room_state = Factory.make_design_page(game_state)

    socket =
      socket
      |> assign(:state, room_state)
      |> assign(:room_gen, pid)

    {:noreply, socket}
  end

  def handle_event("open-trade", params, socket) do
    room_gen = socket.assigns.room_gen
    action = Action.open_trade(params)
    state = GenServer.call(room_gen, action)
    room_state = Factory.make_design_page(state)
    socket = socket |> assign(:state, room_state)

    {:noreply, socket}
  end

  def handle_event("accept-trade", params, socket) do
    room_gen = socket.assigns.room_gen
    action = Action.accept_trade(params)
    state = GenServer.call(room_gen, action)
    room_state = Factory.make_design_page(state)
    socket = socket |> assign(:state, room_state)

    {:noreply, socket}
  end

  def handle_event("submit-to-client", unsigned_params, socket) do
    IO.inspect(unsigned_params, label: "SUBMIT TO CLIENT")

    {:noreply, socket}
  end
end
