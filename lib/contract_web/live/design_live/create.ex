defmodule ContractWeb.DesignLive.Create do
  use ContractWeb, :live_view
  use ContractWeb, :html

  def mount(_params, session, socket) do
    {:ok, socket}
  end

  def handle_event("create-room-four", _unsigned_params, socket) do
    room_id = UXID.generate!(prefix: "room", size: :small)

    {:noreply, push_navigate(socket, to: "/design/four-player/#{room_id}")}
  end
end
