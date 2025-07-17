defmodule ElixirTemplate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirTemplateWeb.Telemetry,
      ElixirTemplate.Repo,
      {DNSCluster, query: Application.get_env(:elixir_template, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirTemplate.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirTemplate.Finch},
      # Start a worker by calling: ElixirTemplate.Worker.start_link(arg)
      # {ElixirTemplate.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirTemplateWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirTemplate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirTemplateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
