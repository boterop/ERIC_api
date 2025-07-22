defmodule EricApi.Adapters.Users do
  @moduledoc """
  The User adapter.
  """

  @behaviour EricApi.Ports.UserRepo

  import Ecto.Query, warn: false
  alias EricApi.Domain.User
  alias EricApi.Repo

  alias EricApi.Adapters.EctoUser

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @impl true
  def list_users do
    EctoUser
    |> Repo.all()
    |> cast_list()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @impl true
  def get_user!(id) do
    EctoUser
    |> Repo.get!(id)
    |> cast()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def create_user(attrs \\ %{}) do
    %EctoUser{}
    |> EctoUser.changeset(attrs)
    |> Repo.insert()
    |> cast()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def update_user(%User{} = user, attrs) do
    user
    |> to_schema()
    |> EctoUser.changeset(attrs)
    |> Repo.update()
    |> cast()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def delete_user(%User{} = user) do
    user
    |> to_schema()
    |> Repo.delete()
    |> cast()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  @impl true
  def change_user(%User{} = user, attrs \\ %{}) do
    user
    |> to_schema()
    |> EctoUser.changeset(attrs)
  end

  defp cast(%EctoUser{} = user) do
    %User{
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password
    }
  end

  defp cast({:ok, %EctoUser{} = user}), do: {:ok, cast(user)}

  defp cast(attrs), do: attrs

  defp cast_list([]), do: []
  defp cast_list([%EctoUser{} = user | rest]), do: [cast(user) | cast_list(rest)]
  defp cast_list(attrs), do: attrs

  defp to_schema(%User{} = user) do
    %EctoUser{
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password
    }
  end
end
