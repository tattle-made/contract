defmodule Contract.Entity.Client do
  alias Contract.Entity.Client
  alias Contract.Canon.Card
  defstruct [:id, :name, :requirements]

  @type t :: %__MODULE__{
          id: UXID.t(),
          name: String.t(),
          requirements: list(Card.t())
        }

  def new(card_count) do
    %Client{
      id: UXID.generate!(prefix: "client", size: :small),
      name: "",
      requirements: 1..card_count |> Enum.map(fn _ -> Card.random() end)
    }
  end
end
