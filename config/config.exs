import Config

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine,
  sheex: PhoenixSlime.LiveViewHTMLEngine

config :phoenix, :json_library, Jason
