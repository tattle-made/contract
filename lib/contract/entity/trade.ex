defmodule Contract.Entity.Trade do
  alias Contract.Entity.Card
  defstruct [:type, :card, :from, :to]

  @type trade_type :: :open | :accept

  @type t :: %__MODULE__{
          type: trade_type(),
          card: Card.t(),
          from: String.t(),
          to: String.t()
        }
end

defmodule Contract.Entity.Trade.NoOpenTrade do
  defexception message: "You are trying to accept a trade that doesn't have an open counterpart"
end

defmodule Contract.Entity.TradeList do
end
