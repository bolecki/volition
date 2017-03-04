# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :volition,
  ecto_repos: [Volition.Repo]

# Configures the endpoint
config :volition, Volition.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1PxEAfWnhi2NQIIR9evfo2rWvxBjdXY1SMAuwhCfywHeGf9MTwsV3C/R7i6s+4Qp",
  render_errors: [view: Volition.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Volition.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
