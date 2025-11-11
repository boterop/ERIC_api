defmodule EricApiWeb.UniversityController do
  use EricApiWeb, :controller

  alias EricApi.Services.Universities

  action_fallback EricApiWeb.FallbackController

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{"country" => country}) do
    with {:ok, answers} <- Universities.search(country) do
      render(conn, :index, answers: answers)
    end
  end
end
