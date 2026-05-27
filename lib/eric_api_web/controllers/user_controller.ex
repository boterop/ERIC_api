defmodule EricApiWeb.UserController do
  use EricApiWeb, :controller

  alias EricApi.Domain.User
  alias EricApi.Services.{Accounts, Guardian}

  action_fallback EricApiWeb.FallbackController

  @email_regex ~r/^[A-Za-z0-9._%+\'-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @spec check_is_professor(User.t()) :: :ok | {:error, :unauthorized}
  defp check_is_professor(%User{type: "professor"}), do: :ok
  defp check_is_professor(_rest), do: {:error, :unauthorized}

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  @spec index_students(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index_students(conn, _params) do
    with [token] <- get_req_header(conn, "authorization"),
         "Bearer " <> token <- token,
         {:ok, %{"sub" => user_id}} <- Guardian.current_claims(token),
         %User{} = user <- Accounts.get_user(user_id),
         :ok <- check_is_professor(user),
         users <- Accounts.list_users() do
      render(conn, :index, users: users)
    end
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    user_params = Map.put(user_params, "type", "student")

    with true <- Regex.match?(@email_regex, user_params["email"]),
         {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    else
      false -> render(conn, :error, message: "Invalid email format")
    end
  end

  @spec me(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def me(conn, _params) do
    with [token] <- get_req_header(conn, "authorization"),
         "Bearer " <> token <- token,
         {:ok, %{"sub" => user_id}} <- Guardian.current_claims(token),
         %User{} = user <- Accounts.get_user(user_id) do
      render(conn, :show, user: user)
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  @spec login(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, token} <- Guardian.authenticate(email, password) do
      render(conn, :show_token, token: token)
    end
  end
end
