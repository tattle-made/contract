defmodule Contract.Entity.Report do
  @moduledoc """
  Track reports against players
  """
  defstruct reports: %{}

  @type t :: %__MODULE__{
          reports: %{
            optional(UXID.uxid_string()) => %{
              by: [UXID.uxid_string()],
              can_remove: boolean()
            }
          }
        }
end

defmodule Contract.Entity.Report.PlayerAlreadyReported do
  defexception message: "You have already reported this player"
end

defmodule Contract.Entity.Report.PlayerDoesNotExist do
  defexception message: "The player you are attempting to report does not exist"
end
