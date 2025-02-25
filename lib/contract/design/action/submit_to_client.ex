defmodule Contract.Design.Action.SubmitToClient do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :from_id, :string
    field :card_ids, {:array, :string}
    field :client_id, UXID
  end

  def changeset(submit_to_client, attrs) do
    submit_to_client
    |> cast(attrs, [:from_id, :card_ids, :client_id])
    |> validate_required([:from_id, :card_ids, :client_id])
  end
end
