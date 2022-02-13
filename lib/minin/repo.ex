defmodule Minin.Repo do
  use Ecto.Repo,
    otp_app: :minin,
    adapter: Ecto.Adapters.Postgres
end
