defmodule EricApiWeb.AnswerControllerTest do
  use EricApiWeb.ConnCase

  import EricApi.DimensionsFixtures

  alias EricApi.Domain.Answer

  @create_attrs %{
    value: 42,
    dimension: :procedural
  }
  @update_attrs %{
    value: 43,
    dimension: :emotional
  }
  @invalid_attrs %{value: nil, dimension: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
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
