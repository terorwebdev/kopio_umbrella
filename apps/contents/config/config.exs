# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :contents,
  ecto_repos: [Contents.Repo]

# Configures the endpoint
config :contents, ContentsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GAk6VDYMY/vONZ1zRgre3/tk7kiiDpQEuZuyZSNKIwV6zBP6Mrf2U4PzCxHfLwil",
  render_errors: [view: ContentsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Contents.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
