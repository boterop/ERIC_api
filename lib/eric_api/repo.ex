defmodule EricApi.Repo do
  use Ecto.Repo,
    otp_app: :eric_api,
    adapter: Ecto.Adapters.Postgres
end
