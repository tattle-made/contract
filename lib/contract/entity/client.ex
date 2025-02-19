defmodule Contract.Entity.Client do
  alias Contract.Entity.Client
  alias Contract.Entity.Card
  defstruct [:id, :name, :requirements]

  @type t :: %__MODULE__{
          id: UXID.t(),
          name: String.t(),
          requirements: list(Card.t())
        }

  def new(card_count, card_factory) do
    %Client{
      id: UXID.generate!(prefix: "client", size: :small),
      name: "",
      requirements: 1..card_count |> Enum.map(fn _ -> card_factory.() end)
    }
  end
end
