defmodule Contract.Entity.Round do
  alias Contract.Entity.Round.RoundNumberMaxExceeded
  alias Contract.Entity.Client
  alias Contract.Entity.Round

  defstruct count: 0,
            total_count: 3,
            clients: nil

  def new(round_count) do
    case round_count do
      1 ->
        %Round{count: round_count, clients: Client.new(1)}

      n when n > 1 and n <= 5 ->
        clients = for _ <- 1..4, do: Client.new(:rand.uniform(2) + 1)

        %Round{count: round_count, clients: clients}

      _ ->
        raise RoundNumberMaxExceeded
    end
  end

  # defp new(client_count) do
  # end
end

defmodule Contract.Entity.Round.RoundNumberMaxExceeded do
  defexception message: "You have exceeded the max allowed round count"
end
