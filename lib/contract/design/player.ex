defmodule Contract.Design.Player do
  defstruct [
    :id,
    :name,
    :type,
    :hand,
    :other_staff,
    :other_freelancers,
    :pending_trades,
    :staging_area
  ]
end
