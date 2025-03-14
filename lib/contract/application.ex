defmodule Contract.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ContractWeb.Telemetry,
      Contract.Repo,
      {DNSCluster, query: Application.get_env(:contract, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Contract.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Contract.Finch},
      Contract.Design.RoomSupervisor,
      # Start a worker by calling: Contract.Worker.start_link(arg)
      # {Contract.Worker, arg},
      # Start to serve requests, typically the last entry
      ContractWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Contract.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ContractWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
