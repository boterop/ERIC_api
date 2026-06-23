defmodule EricApiWeb.ScoreController do
  use EricApiWeb, :controller

  alias EricApi.Domain.User
  alias EricApi.Services.Accounts
  alias EricApi.Workers.GenerateScoreExcel

  @spec gen_excel(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def gen_excel(conn, _params) do
    with %{"sub" => user_id} <- Guardian.Plug.current_claims(conn),
         %User{email: email} = user <- Accounts.get_user(user_id),
         :ok <- Accounts.check_is_professor(user),
         %{} = oban_job <- GenerateScoreExcel.new(%{professor_id: user_id, email: email}),
         {:ok, %Oban.Job{}} <- Oban.insert(oban_job) do
      send_resp(conn, :ok, "ok")
    else
      error ->
        send_resp(conn, :bad_request, inspect(error))
    end
  end
end
