defmodule Contents.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Contents.Repo,
      # Start the endpoint when the application starts
      ContentsWeb.Endpoint,
      # Starts a worker by calling: Contents.Worker.start_link(arg)
      # {Contents.Worker, arg},
      Contents.ContentStartup
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Contents.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ContentsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
