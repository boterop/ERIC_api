defmodule EricApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use EricApiWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  @impl true
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: EricApiWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: EricApiWeb.ErrorHTML, json: EricApiWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :internal_server_error}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(html: EricApiWeb.ErrorHTML, json: EricApiWeb.ErrorJSON)
    |> render(:"500")
  end

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "invalid_credentials"})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "unauthorized"})
  end

  # This clause handles generic string errors
  def call(conn, {:error, message}) when is_binary(message) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(json: EricApiWeb.ErrorJSON)
    |> render(:"500", errors: %{detail: message})
  end

  def call(conn, nil), do: call(conn, {:error, :not_found})

  def call(conn, _rest), do: call(conn, {:error, :internal_server_error})
end
