defmodule EricApiWeb.UserControllerTest do
  use EricApiWeb.ConnCase

  import EricApi.AccountsFixtures

  alias EricApi.Domain.User
  alias EricApi.Services.Guardian

  @create_attrs %{
    name: "some name",
    password: "some password",
    email: "some email"
  }
  @update_attrs %{
    name: "some updated name",
    password: "some updated password",
    email: "some updated email"
  }
  @invalid_attrs %{name: nil, password: nil, email: nil}

  setup %{conn: conn} do
    user = user_fixture(%{email: "authored_email"})
    {:ok, token} = Guardian.resource_from_claims(%{"sub" => user.id})

    auth_conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put_req_header("accept", "application/json")

    {:ok, conn: auth_conn}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      user = get(conn, ~p"/api/users/#{id}")
      user_data = json_response(user, 200)["data"]

      assert %{
               "id" => ^id,
               "email" => "some email",
               "name" => "some name"
             } = user_data

      assert user_data["password"] == nil
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      user = get(conn, ~p"/api/users/#{id}")
      user_data = json_response(user, 200)["data"]

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name"
             } = user_data

      assert user_data["password"] == nil
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  describe "login user" do
    setup [:create_user]

    test "logs the user in", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/login", user: %{email: user.email, password: "some password"})
      token = json_response(conn, 200)["data"]
      assert is_binary(token)
    end

    test "logs the user in with invalid credentials", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/login", user: %{email: user.email, password: "invalid password"})
      assert json_response(conn, 401)["error"] == "invalid_credentials"
    end
  end

  defp create_user(_attrs) do
    user = user_fixture()
    %{user: user}
  end
end
