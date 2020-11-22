defmodule Sugarcane.Repo do
  use Ecto.Repo,
    otp_app: :sugarcane,
    adapter: Ecto.Adapters.Postgres
end
