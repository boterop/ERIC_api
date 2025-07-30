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
    with {:ok, %Answer{} = answer} <- Dimensions.create_answer(answer_params) do
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
end
