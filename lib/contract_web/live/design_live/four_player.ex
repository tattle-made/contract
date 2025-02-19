defmodule ContractWeb.DesignLive.FourPlayer do
  import ContractWeb.Molecules
  alias Contract.Entity.Card

  use ContractWeb, :live_view
  use ContractWeb, :html

  def mount(_params, session, socket) do
    {:ok, socket}
  end
end
