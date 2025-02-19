defmodule ContractWeb.Molecules do
  alias Contract.Entity.Card
  use ContractWeb, :html

  attr :id, :string, required: true
  attr :card, Card
  attr :peers, :list

  def tradable_card(assigns) do
    ~H"""
    <div class="p-4 border">
      <div class=" w-fit border-slate-500 border-2 rounded-md overflow-clip ">
        <div class="p-2 bg-green-200">
          <p class="m-2 text-3xl">{shape_icon(@card.shape)}</p>
          <p>{Atom.to_string(@card.property)}</p>
        </div>
        <div class="mb-2 h-0.5 bg-slate-500"></div>
        <div class="p-2">
          <button phx-click={show_peers("##{@id}-peers")}>
            trade
          </button>
          <div id={"#{@id}-peers"} class="hidden p-2 border-slate-200 border-2 w-fit">
            <button phx-click={hide_peers("##{@id}-peers")} class="mb-2">
              <.icon name="hero-x-mark-solid" class="h-5 w-5" />
            </button>
            <button phx-click={hide_peers("##{@id}-peers")} class="block">krys</button>
            <button phx-click={hide_peers("##{@id}-peers")} class="block">farah</button>
            <button phx-click={hide_peers("##{@id}-peers")} class="block">aman</button>
          </div>
        </div>
        <div class="mt-1 mb-2 h-0.5 bg-slate-200"></div>
        <div class="p-2">
          <button>secret swap</button>
        </div>
      </div>
    </div>
    """
  end

  def shape_icon(shape) do
    shape_to_icon = %{
      star: "⭐",
      crescent_moon: "🌙",
      comet: "☄️",
      asteroid: "✨"
    }

    shape_to_icon[shape]
  end

  def show_peers(js \\ %JS{}, selector) do
    js
    |> JS.remove_class("hidden", to: selector)
    |> JS.add_class("visible", to: selector)
  end

  def hide_peers(js \\ %JS{}, selector) do
    js
    |> JS.remove_class("visible", to: selector)
    |> JS.add_class("hidden", to: selector)
  end
end
