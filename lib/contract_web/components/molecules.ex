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

  # <div id="tooltip-default" role="tooltip" class="absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-900 rounded-lg shadow-xs opacity-0 tooltip dark:bg-gray-700">
  #     Tooltip content
  #     <div class="tooltip-arrow" data-popper-arrow></div>
  # </div>

  def card_compact(assigns) do
    ~H"""
    <div class="item flex flex-col" data-card-id={@id}>
      <div class="w-fit bg-blue-400 flex items-center justify-center  border-slate-500 border-2 rounded-md overflow-clip">
        <div class="">
          <p
            class="summary w-4 h-4 m-2 text-sm"
            title={"#{shape_icon(@shape)} : #{Atom.to_string(@property)}"}
          >
            {shape_icon(@shape)}
          </p>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :card, Card
  attr :peers, :list
  attr :secret_peers, :list
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

        <button
          data-popover-target={"popover-trade-#{@card.id}"}
          data-popover-placement="bottom"
          type="button"
          class="hover:text-slate-600 rounded-lg p-2 "
        >
          Trade With
        </button>

        <div
          data-popover
          id={"popover-trade-#{@card.id}"}
          role="tooltip"
          class="absolute z-10 invisible inline-block w-fit text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-xs opacity-0 dark:text-gray-400 dark:bg-gray-800 dark:border-gray-600 p-2"
        >
          <div :for={peer <- @peers}>
            <div class="px-3 py-2">
              <button phx-click={
                JS.push("open-trade", value: %{card_id: @card.id, from_id: @id, to_id: peer.id})
              }>
                {peer.name}
              </button>
            </div>
          </div>
          <div data-popper-arrow></div>
        </div>

        <div :if={@player_type == :freelancer}>
          <button
            data-popover-target={"popover-secret-swap-#{@card.id}"}
            data-popover-placement="bottom"
            type="button"
            class="hover:text-slate-600  rounded-lg p-2 "
          >
            Secret Swap
          </button>

          <div
            data-popover
            id={"popover-secret-swap-#{@card.id}"}
            role="tooltip"
            class="absolute z-10 invisible inline-block w-fit text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-xs opacity-0 dark:text-gray-400 dark:bg-gray-800 dark:border-gray-600 p-2"
          >
            <div :for={secret_peer <- @secret_peers}>
              <div class="px-3 py-2">
                <button>{secret_peer.name}</button>
              </div>
            </div>
            <div data-popper-arrow></div>
          </div>
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
  attr :peers, :list

  def client_staging(assigns) do
    ~H"""
    <section
      id={"staging-player-#{@id}"}
      data-player-id={@id}
      class="border-t-2 pt-2 flex flex-col flex-wrap"
      phx-hook="ClientStaging"
    >
      <div class="flex flex-row flex-wrap gap-6">
        <div class="staging w-fit  container   flex flex-row gap-2 overflow-x-scroll">
          <div :for={space <- 1..@space.count} id={"staging-#{space}-#{@id}"}>
            <div class="dropzone dropzone-a w-12 h-12 border-2 border-green-200 rounded-md "></div>
          </div>
        </div>
        <div class="w-fit  overflow-x-scroll ">
          <div class="container  flex flex-row flex-wrap gap-2">
            <div :for={card <- @hand}>
              <div class="dropzone  ">
                <.card_compact id={card.id} shape={card.shape} property={card.property} />
              </div>
            </div>
          </div>
        </div>
      </div>

      <button
        id={"submit_#{@id}"}
        data-popover-target={"popover_submit_#{@id}"}
        data-popover-placement="bottom"
        type="button"
        class="mt-4 rounded-md bg-amber-500 pl-2 pr-2"
      >
        Submit To
      </button>

      <div
        data-popover
        id={"popover_submit_#{@id}"}
        role="tooltip"
        class="absolute z-10 invisible inline-block w-fit text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-xs opacity-0 dark:text-gray-400 dark:bg-gray-800 dark:border-gray-600 p-2"
      >
        <div :for={client <- @clients}>
          <div class="px-3 py-2">
            <button phx-click={
              JS.dispatch("contract:click",
                to: "#submit_#{@id}",
                detail: %{from_id: @id, client_id: client.id}
              )
            }>
              {client.name}
            </button>
          </div>
        </div>
        <div data-popper-arrow></div>
      </div>
    </section>
    """
  end

  attr :id, :string, required: true
  slot :label, required: true
  slot :options

  def popover(assigns) do
    ~H"""
    <button
      data-popover-target={@id}
      data-popover-placement="bottom"
      type="button"
      class="hover:text-slate-600 rounded-lg p-2 "
    >
      {render_slot(@label)}
    </button>

    <div
      data-popover
      id={@id}
      role="tooltip"
      class="absolute z-10 invisible inline-block w-fit text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-xs opacity-0 dark:text-gray-400 dark:bg-gray-800 dark:border-gray-600 p-2"
    >
      {render_slot(@options) || "Options"}
      <div data-popper-arrow></div>
    </div>
    """
  end
end
