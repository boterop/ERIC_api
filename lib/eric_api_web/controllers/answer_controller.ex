defmodule EricApiWeb.AnswerController do
  use EricApiWeb, :controller

  alias EricApi.Domain.Answer
  alias EricApi.Services.Dimensions

  action_fallback EricApiWeb.FallbackController

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    answers = Dimensions.list_answers()
    render(conn, :index, answers: answers)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"answer" => answer_params}) do
    with %{"sub" => user_id} <- Guardian.Plug.current_claims(conn),
         %{} = params <- Map.put(answer_params, "user_id", user_id),
         {:ok, %Answer{} = answer} <- Dimensions.create_answer(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/answers/#{answer}")
      |> render(:show, answer: answer)
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    answer = Dimensions.get_answer!(id)
    render(conn, :show, answer: answer)
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Dimensions.get_answer!(id)

    with {:ok, %Answer{} = answer} <- Dimensions.update_answer(answer, answer_params) do
      render(conn, :show, answer: answer)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    answer = Dimensions.get_answer!(id)

    with {:ok, %Answer{}} <- Dimensions.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end

  @spec question(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def question(conn, %{"question" => question}) do
    with %{"sub" => user_id} <- Guardian.Plug.current_claims(conn),
         %Answer{} = answer <- Dimensions.get_by(question: question, user_id: user_id) do
      render(conn, :show, answer: answer)
    end
  end

  @spec dimension(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def dimension(conn, %{"dimension" => dimension}) do
    with %{"sub" => user_id} <- Guardian.Plug.current_claims(conn),
         {:ok, valid_dimension} <- cast_dimension(dimension),
         answers <- Dimensions.get_all_by(dimension: valid_dimension, user_id: user_id) do
      render(conn, :index, answers: answers)
    end
  end

  defp cast_dimension("procedural"), do: {:ok, :procedural}
  defp cast_dimension("emotional"), do: {:ok, :emotional}
  defp cast_dimension("cognitive"), do: {:ok, :cognitive}
  defp cast_dimension("critical"), do: {:ok, :critical}
  defp cast_dimension(_dimension), do: {:error, :not_found}
end
