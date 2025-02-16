defmodule Contract.Entity.Trade do
  defstruct [:type, :card_id, :from, :to]

  @type trade_type :: :open | :accept

  @type t :: %__MODULE__{
          type: trade_type(),
          card_id: String.t(),
          from: String.t(),
          to: String.t()
        }
end
