defmodule Contract.Entity.Card do
  alias Contract.Entity.Card
  defstruct [:id, :shape, :property]

  @type t :: %__MODULE__{
          id: UXID.uxid_string(),
          shape: atom(),
          property: atom()
        }

  def value(%Card{} = card) do
    card
    |> Map.from_struct()
    |> Map.delete(:id)
  end
end
