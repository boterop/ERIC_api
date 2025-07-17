defmodule ElixirTemplate.Repo do
  use Ecto.Repo,
    otp_app: :elixir_template,
    adapter: Ecto.Adapters.Postgres
end
