defmodule EricApiWeb.ScoreController do
  use EricApiWeb, :controller

  alias EricApi.Domain.{Answer, User}
  alias EricApi.Services.Accounts

  @spec gen_excel(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def gen_excel(conn, _params) do
    with %{"sub" => user_id} <- Guardian.Plug.current_claims(conn),
         %User{} = user <- Accounts.get_user(user_id),
         :ok <- Accounts.check_is_professor(user) do
      send_resp(conn, :ok, "ok")
    end
  end
end
