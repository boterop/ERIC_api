defmodule EricApiWeb.Auth.GuardianErrorHandler do
  @moduledoc """
  The Guardian Error Handler.
  """

  import Plug.Conn

  @spec auth_error(Plug.Conn.t(), tuple(), any()) :: Plug.Conn.t()
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
