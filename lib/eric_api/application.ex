defmodule EricApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EricApiWeb.Telemetry,
      EricApi.Repo,
      {DNSCluster, query: Application.get_env(:eric_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EricApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EricApi.Finch},
      # Start a worker by calling: EricApi.Worker.start_link(arg)
      # {EricApi.Worker, arg},
      # Start to serve requests, typically the last entry
      EricApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EricApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EricApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
