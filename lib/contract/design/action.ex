defmodule Contract.Design.Action do
  alias Contract.Design.Action.AcceptTrade
  alias Contract.Design.Action
  alias Contract.Design.Action.OpenTrade
  import Ecto.Changeset

  defstruct [:type, :payload]

  @type t :: %__MODULE__{
          type: atom(),
          payload: map()
        }

  def open_trade(attrs) do
    action =
      %OpenTrade{}
      |> OpenTrade.changeset(attrs)
      |> apply_changes()

    %Action{
      type: :open_trade,
      payload: action
    }
  end

  def accept_trade(attrs) do
    action =
      %AcceptTrade{}
      |> AcceptTrade.changeset(attrs)
      |> apply_changes()

    %Action{
      type: :accept_trade,
      payload: action
    }
  end
end
