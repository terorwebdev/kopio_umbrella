defmodule Kopio.Repo do
  use Ecto.Repo,
    otp_app: :kopio,
    adapter: Ecto.Adapters.Postgres
end
