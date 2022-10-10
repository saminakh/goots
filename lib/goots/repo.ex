defmodule Goots.Repo do
  use Ecto.Repo,
    otp_app: :goots,
    adapter: Ecto.Adapters.Postgres
end
