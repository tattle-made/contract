defmodule Contract.Design.Action.AcceptTrade do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :from_id, :string
    field :to_id, :string
    field :card_id, :string
  end

  def changeset(accept_trade, attrs) do
    accept_trade
    |> cast(attrs, [:from_id, :to_id, :card_id])
    |> validate_required([:from_id, :to_id, :card_id])
  end
end
