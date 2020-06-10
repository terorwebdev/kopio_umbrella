defmodule Contents.Repo do
  use Ecto.Repo,
    otp_app: :contents,
    adapter: Ecto.Adapters.Postgres
end
