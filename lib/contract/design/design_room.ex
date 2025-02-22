defmodule Contract.Design.DesignRoom do
  defstruct [
    :room,
    :round,
    :clients,
    :staff_players,
    :freelance_players,
    :public_logs,
    :secret_logs
  ]
end
