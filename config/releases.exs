# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

local_build = (System.get_env("LOCAL_BUILD") || "false") == "true"

config :goots, Goots.Repo,
  ssl: !local_build,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

host = System.get_env("HOST")
port = String.to_integer(System.get_env("PORT") || "4000")

signing_salt = System.get_env("SIGNING_SALT")

config :goots,
  session_salt: System.get_env("SESSION_SALT"),
  production_env: System.get_env("PRODUCTION_ENV")

config :goots, GootsWeb.Endpoint,
  secret_key_base: secret_key_base,
  live_view: [signing_salt: signing_salt]

if local_build do
  config :goots, GootsWeb.Endpoint,
    http: [port: port],
    url: [scheme: "http", host: host, port: port]
else
  config :goots, GootsWeb.Endpoint,
    http: [port: port],
    url: [scheme: "https", host: host, port: 443]
end

