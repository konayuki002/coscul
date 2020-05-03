defmodule Coscul.Repo do
  use Ecto.Repo,
    otp_app: :coscul,
    adapter: Ecto.Adapters.Postgres
end
