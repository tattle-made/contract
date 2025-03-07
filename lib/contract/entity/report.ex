defmodule Contract.Entity.Report do
  @moduledoc """
  Track reports against players.
  """
  defstruct by: [], can_remove: nil, valid: nil

  @type t :: %__MODULE__{
          by: [UXID.uxid_string()],
          can_remove: boolean(),
          valid: boolean()
        }
end

defmodule Contract.Entity.Report.PlayerAlreadyReported do
  defexception message: "You have already reported this player"
end

defmodule Contract.Entity.Report.PlayerDoesNotExist do
  defexception message: "The player you are attempting to report does not exist"
end
