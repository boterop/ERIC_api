defmodule EricApiWeb.UserJSON do
  alias EricApi.Domain.User

  @doc """
  Renders a list of users.
  """
  @spec index(map()) :: map()
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  @spec show(map()) :: map()
  def show(%{user: user}) do
    %{data: data(user)}
  end

  @spec show_token(map()) :: map()
  def show_token(%{token: token}) do
    %{data: token}
  end

  @spec data(User.t()) :: map()
  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
