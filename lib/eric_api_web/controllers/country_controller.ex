defmodule EricApiWeb.CountryController do
  use EricApiWeb, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    path = "priv/json/countries.json"

    with {:ok, content} <- File.read(path),
         {:ok, json} <- Jason.decode(content) do
      json(conn, json)
    end
  end
end
