defmodule EricApiWeb.AnswerControllerTest do
  use EricApiWeb.ConnCase

  import EricApi.{AccountsFixtures, DimensionsFixtures}

  alias EricApi.Domain.Answer
  alias EricApi.Services.Guardian

  @create_attrs %{
    question: 1,
    value: 42,
    dimension: :procedural
  }
  @update_attrs %{
    question: 1,
    value: 43,
    dimension: :emotional
  }
  @invalid_attrs %{question: nil, value: nil, dimension: nil}

  setup %{conn: conn} do
    user = user_fixture(%{email: "auth@mail.com", name: "Auth"})
    {:ok, token} = Guardian.resource_from_claims(%{"sub" => user.id})

    auth_conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put_req_header("accept", "application/json")

    {:ok, conn: auth_conn}
  end

  describe "index" do
    test "lists all answers", %{conn: conn} do
      conn = get(conn, ~p"/api/answers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create answer" do
    test "renders answer when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/answers", answer: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      answer = get(conn, ~p"/api/answers/#{id}")

      assert %{
               "id" => ^id,
               "question" => 1,
               "dimension" => "procedural",
               "value" => 42
             } = json_response(answer, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/answers", answer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update answer" do
    setup [:create_answer]

    test "renders answer when data is valid", %{conn: conn, answer: %Answer{id: id} = answer} do
      conn = put(conn, ~p"/api/answers/#{answer}", answer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      answer = get(conn, ~p"/api/answers/#{id}")

      assert %{
               "id" => ^id,
               "dimension" => "emotional",
               "value" => 43
             } = json_response(answer, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, answer: answer} do
      conn = put(conn, ~p"/api/answers/#{answer}", answer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete answer" do
    setup [:create_answer]

    test "deletes chosen answer", %{conn: conn, answer: answer} do
      conn = delete(conn, ~p"/api/answers/#{answer}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/answers/#{answer}")
      end
    end
  end

  defp create_answer(_attrs) do
    answer = answer_fixture()
    %{answer: answer}
  end
end
