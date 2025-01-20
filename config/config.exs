# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :exploration,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :exploration, ExplorationWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ExplorationWeb.ErrorHTML, json: ExplorationWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Exploration.PubSub,
  live_view: [signing_salt: "0D8dc/Jc"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :exploration, Label.Mailer, 
  adapter: Swoosh.Adapters.SMTP,
  relay: System.get_env("SMTP_SERVER"),
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  port: 587,
  ssl: false,
  auth: :always,
  no_mx_lookups: true,
  retries: 1

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  exploration: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  exploration: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# --- Pour Markdown ---
# config :phoenix, :template_engines, md: PhoenixMarkdown.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
