defmodule Contract.Canon.Card do
  alias Contract.Canon.Card
  defstruct [:shape, :property]

  @shapes [:star, :crescent_moon, :comet, :asteroid]
  @internal_properties [:supplies_request, :expense_report, :team_memo]
  @external_properties [:marketing_budget, :creative_brief, :pitch_deck, :project_estimate]
  @properties @internal_properties ++ @external_properties

  def new(shape, property) when shape in @shapes and property in @properties do
    %Card{shape: shape, property: property}
  end

  def random() do
    %Card{
      shape: Enum.take_random(@shapes, 1),
      property: Enum.take_random(@properties, 1)
    }
  end
end
