defmodule Salt.Repo do
  use Ecto.Repo,
    otp_app: :salt,
    adapter: Ecto.Adapters.Postgres
end
