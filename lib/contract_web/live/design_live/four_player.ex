defmodule ContractWeb.DesignLive.FourPlayer do
  import ContractWeb.Molecules
  alias Contract.Factory
  alias Contract.Design.RoomSupervisor
  alias Contract.Entity.Card
  alias Contract.Entity.Client

  use ContractWeb, :live_view
  use ContractWeb, :html

  def mount(_params, session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"room_id" => room_id}, _uri, socket) do
    pid =
      case RoomSupervisor.room_gen!(room_id) do
        {:ok, pid} ->
          pid

        {:error, :not_found} ->
          room_reserved = RoomSupervisor.reserve(room_id)
          {:ok, pid} = RoomSupervisor.room_gen!(room_reserved.id)
          pid
      end

    game_state = :sys.get_state(pid)
    room_state = Factory.make_design_page(game_state)
    assign(socket, :state, room_state)

    socket =
      socket
      |> assign(:state, room_state)
      |> assign(:room_gen, pid)

    {:noreply, socket}
  end

  def handle_event("open-trade", unsigned_params, socket) do
    IO.inspect(unsigned_params, label: "OPEN TRADE")

    {:noreply, socket}
  end

  def handle_event("submit-to-client", unsigned_params, socket) do
    IO.inspect(unsigned_params, label: "SUBMIT TO CLIENT")

    {:noreply, socket}
  end
end
