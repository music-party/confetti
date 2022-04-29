defmodule ConfettiWeb.Router do
  @moduledoc """
  Phoenix Router
  """
  use ConfettiWeb, :router

  import Phoenix.LiveDashboard.Router

  alias ConfettiWeb.Plug

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plug.Authenticate, repo: Confetti.Repo
  end

  scope "/auth", ConfettiWeb do
    pipe_through :auth
    get "/spotify", AuthController, :request, as: "spotify_auth"
    get "/spotify/callback", AuthController, :callback, as: "spotify_auth"
    get "/log-out", AuthController, :delete, as: "log_out"
  end

  live_dashboard "/dashboard", metrics: ConfettiWeb.Telemetry

  forward "/graphql", Absinthe.Plug, schema: ConfettiWeb.Schema

  if Mix.env() == :dev do
    forward "/graphql-playground", Absinthe.Plug.GraphiQL,
      schema: ConfettiWeb.Schema,
      interface: :playground
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
