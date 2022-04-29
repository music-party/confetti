# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :confetti,
  ecto_repos: [Confetti.Repo]

config :confetti, :generators, binary_id: true

# Set environment
config :confetti, env: Mix.env()

# Configures the endpoint
config :confetti, ConfettiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ConfettiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Confetti.PubSub,
  live_view: [signing_salt: "zjrwyfWA"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :confetti, Confetti.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    spotify: {Ueberauth.Strategy.Spotify, [default_scope: "user-read-email user-read-private"]},
  ]

config :ueberauth, Ueberauth.Strategy.Spotify.OAuth,
  client_id: System.get_env("SPOTIFY_CLIENT_ID"),
  client_secret: System.get_env("SPOTIFY_CLIENT_SECRET"),
  redirect_uri: System.get_env("SPOTIFY_REDIRECT_URI")

config :oauth2, debug: config_env() in [:dev, :test]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
