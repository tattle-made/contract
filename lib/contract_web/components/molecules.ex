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
    <div class="item flex flex-col">
      <div
        id={@id}
        class=" w-fit bg-blue-400 flex items-center justify-center  border-slate-500 border-2 rounded-md overflow-clip"
        phx-hook="TooltipHook"
      >
        <div class="">
          <p
            class="summary w-4 h-4 m-2 text-sm"
            title={"#{shape_icon(@shape)} : #{Atom.to_string(@property)}"}
          >
            {shape_icon(@shape)}
          </p>
        </div>

        <%!-- <div class="description invisible p-2 bg-slate-100">
        <p class="m-2 text-3xl">{shape_icon(@shape)}</p>
        <p class="text-sm">{Atom.to_string(@property)}</p>
      </div> --%>
      </div>
      <%!-- <p class="text-xs ">{Atom.to_string(@property)}</p> --%>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :card, Card
  attr :peers, :list
  attr :player_type, :atom

  def tradable_card(assigns) do
    ~H"""
    <div>
      <div class="w-fit border-slate-500 border-2 rounded-md overflow-clip ">
        <div class="p-2 bg-green-200">
          <%!-- <.card shape={@card.shape} property={@card.property} /> --%>
          <.card_compact id={@card.id} shape={@card.shape} property={@card.property} />
        </div>
        <div class="mb-2 h-0.5 bg-slate-500"></div>
        <div class="p-2">
          <button phx-click={show_peers("##{@card.id}-peers")}>
            trade
          </button>
          <div
            id={"#{@card.id}-peers"}
            class="hidden p-2 border-slate-200 border-2 min-w-fit w-40 z-10 absolute bg-slate-200 rounded-md "
          >
            <button phx-click={hide_peers("##{@card.id}-peers")} class="mb-2">
              <.icon name="hero-x-mark-solid" class="h-5 w-5" />
            </button>
            <div :for={peer <- @peers}>
              <button phx-click={hide_peers("##{@card.id}-peers")} class="block">{peer}</button>
            </div>
          </div>
        </div>

        <div :if={@player_type == :freelancer} class="p-2">
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

  attr :id, :string
  attr :hand, :list
  attr :clients, :list
  attr :space, :map

  def client_staging(assigns) do
    ~H"""
    <section id={@id} class="border-t-2 pt-2 flex flex-row flex-wrap" phx-hook="ClientStaging">
      <div class=" overflow-x-scroll ">
        <div id="cards" class="container  flex flex-row flex-wrap gap-2">
          <div :for={card <- @hand}>
            <div class="dropzone  ">
              <.card_compact id={card.id} shape={card.shape} property={card.property} />
            </div>
          </div>
        </div>
      </div>

      <div class="container mt-2  flex flex-row gap-2 overflow-x-scroll">
        <div :for={_ <- 1..@space.count} id="staging">
          <div class="dropzone dropzone-a w-12 h-12 border-2 border-green-200 rounded-md "></div>
        </div>
      </div>

      <button class="staging_submit mt-4 rounded-md bg-yellow-300 pl-2 pr-2">submit</button>
    </section>
    """
  end
end
