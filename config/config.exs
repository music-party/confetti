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

# Import secrets
import_config "secrets.exs"

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

# Add Spotify configs
config :confetti,
  spotify_client_id: "1cfd20a1ff284373b7561b98cfc87ac2",
  # spotify_client_secret: "<client_secret>",
  spotify_redirect_uri: "https://api.music-party.app/callback",
  spotify_scope: [],
  spotify_show_dialog: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Import environment specific secrets
# import_config "#{config_env()}.secrets.exs"
