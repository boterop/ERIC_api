defmodule EricApiWeb.UniversityControllerTest do
  use EricApiWeb.ConnCase

  import EricApi.AccountsFixtures

  alias EricApi.Services.Guardian

  setup %{conn: conn} do
    user = user_fixture(%{email: "test@example.com"})
    {:ok, token} = Guardian.resource_from_claims(%{"sub" => user.id})

    auth_conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put_req_header("accept", "application/json")

    {:ok, conn: auth_conn}
  end

  describe "index" do
    test "lists all universities for a given country", %{conn: conn} do
      conn = get(conn, ~p"/api/universities?country=Colombia")
      response = json_response(conn, 200)

      assert %{"data" => universities} = response
      assert is_list(universities)
      assert length(universities) == 2

      [first_university | _] = universities

      assert %{
               "name" => "Universidad Nacional de Colombia",
               "country" => "Colombia",
               "state_province" => "Bogotá",
               "domains" => ["unal.edu.co"],
               "alpha_two_code" => "CO",
               "web_pages" => ["http://www.unal.edu.co/"]
             } = first_university
    end

    test "returns empty list for country with no universities", %{conn: conn} do
      conn = get(conn, ~p"/api/universities?country=InvalidCountry")
      response = json_response(conn, 200)

      assert %{"data" => universities} = response
      assert universities == []
    end

    test "returns error when service fails", %{conn: conn} do
      conn = get(conn, ~p"/api/universities?country=ErrorCountry")
      response = json_response(conn, 500)

      assert %{"errors" => %{"detail" => "HTTP request failed with status 500"}} = response
    end

    test "returns empty list for unknown country", %{conn: conn} do
      conn = get(conn, ~p"/api/universities?country=UnknownCountry")
      response = json_response(conn, 200)

      assert %{"data" => universities} = response
      assert universities == []
    end
  end
end
