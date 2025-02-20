defmodule ContractWeb.Molecules do
  alias Contract.Entity.Card
  use ContractWeb, :html

  def card(assigns) do
    ~H"""
    <div class="p-2 bg-green-200">
      <p class="m-2 text-3xl">{shape_icon(@shape)}</p>
      <p class="text-sm">{Atom.to_string(@property)}</p>
    </div>
    """
  end

  def card_compact(assigns) do
    ~H"""
    <div
      id={@id}
      class="item bg-blue-400 flex items-center justify-center  border-slate-500 border-2 rounded-md overflow-clip"
      phx-hook="TooltipHook"
    >
      <div>
        <p class="summary m-2 text-sm">{shape_icon(@shape)}</p>
      </div>
      <div class="description p-2 bg-slate-100">
        <p class="m-2 text-3xl">{shape_icon(@shape)}</p>
        <p class="text-sm">{Atom.to_string(@property)}</p>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :card, Card
  attr :peers, :list

  def tradable_card(assigns) do
    ~H"""
    <div>
      <div class=" w-fit border-slate-500 border-2 rounded-md overflow-clip ">
        <div class="p-2 bg-green-200">
          <.card shape={@card.shape} property={@card.property} />
        </div>
        <div class="mb-2 h-0.5 bg-slate-500"></div>
        <div class="p-2">
          <button phx-click={show_peers("##{@id}-peers")}>
            trade
          </button>
          <div
            id={"#{@id}-peers"}
            class="hidden p-2 border-slate-200 border-2 min-w-fit w-40 z-10 absolute bg-slate-200 rounded-md "
          >
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

  attr :hand, :list
  attr :clients, :list
  attr :space, :map

  def client_staging(assigns) do
    ~H"""
    <section id="staging-player-123" class="border-2 border-slate-200 p-2  " phx-hook="ClientStaging">
      <h1>Staging Area</h1>
      <div class="h-4"></div>
      <p>hand</p>
      <div class=" overflow-x-scroll ">
        <div id="cards" class="container  flex flex-row flex-wrap gap-2">
          <div :for={card <- @hand}>
            <div class="dropzone  ">
              <.card_compact id={card.id} shape={card.shape} property={card.property} />
            </div>
          </div>
        </div>
      </div>

      <p class="font-semibold mt-8">Staging</p>
      <div class="container mt-2 border-2 border-slate-500 p-2 flex flex-row gap-2 w-1/4 overflow-x-scroll">
        <div :for={_ <- 1..@space.count} id="staging">
          <div class="dropzone p-2 dropzone-a min-w-24 w-fit min-h-20 h-fit border-2 border-green-200 rounded-md ">
          </div>
        </div>
      </div>

      <button class="staging_submit mt-4 rounded-md bg-yellow-300 pl-2 pr-2">submit</button>
    </section>
    """
  end
end
