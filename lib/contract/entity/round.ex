defmodule Contract.Entity.Round do
  alias Contract.Entity.Round.RoundNumberMaxExceeded
  alias Contract.Entity.Round.ClientNotFound
  alias Contract.Entity.Client
  alias Contract.Entity.Round

  defstruct count: 0,
            total_count: 3,
            clients: nil

  def new(round_count, card_factory) do
    case round_count do
      1 ->
        %Round{count: round_count, clients: Client.new(1, card_factory)}

      n when n > 1 and n <= 5 ->
        clients = for _ <- 1..4, do: Client.new(:rand.uniform(2) + 1, card_factory)

        %Round{count: round_count, clients: clients}

      _ ->
        raise RoundNumberMaxExceeded
    end
  end

  def client(%Round{} = round, client_id) do
    case round.clients do
      %Client{} = client ->
        if client.id == client_id, do: client, else: raise(ClientNotFound)

      clients when is_list(clients) ->
        client = clients[client_id]
        if client.id == client_id, do: client, else: raise(ClientNotFound)
    end
  end
end

defmodule Contract.Entity.Round.RoundNumberMaxExceeded do
  defexception message: "You have exceeded the max allowed round count"
end

defmodule Contract.Entity.Round.ClientNotFound do
  defexception message: "No client found with the matching ID"
end
