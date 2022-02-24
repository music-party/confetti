defmodule Confetti.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Confetti.Repo,
      # Start the Telemetry supervisor
      ConfettiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Confetti.PubSub},
      # Start the Endpoint (http/https)
      ConfettiWeb.Endpoint
      # Start a worker by calling: Confetti.Worker.start_link(arg)
      # {Confetti.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Confetti.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ConfettiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
