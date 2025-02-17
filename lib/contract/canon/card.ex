defmodule Contract.Canon.Card do
  alias Contract.Canon.Card
  defstruct [:id, :shape, :property]

  @type t :: %__MODULE__{
          id: UXID.uxid_string(),
          shape: atom(),
          property: atom()
        }

  @shapes [:star, :crescent_moon, :comet, :asteroid]
  @internal_properties [:supplies_request, :expense_report, :team_memo]
  @external_properties [:marketing_budget, :creative_brief, :pitch_deck, :project_estimate]
  @properties @internal_properties ++ @external_properties

  def new(shape, property) when shape in @shapes and property in @properties do
    %Card{id: UXID.generate!(prefix: "card", size: :small), shape: shape, property: property}
  end

  def random() do
    %Card{
      id: UXID.generate!(prefix: "card", size: :small),
      shape: Enum.take_random(@shapes, 1) |> hd,
      property: Enum.take_random(@properties, 1) |> hd
    }
  end
end
