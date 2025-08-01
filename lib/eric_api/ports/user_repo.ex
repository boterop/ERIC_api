defmodule EricApi.Ports.UserRepo do
  @moduledoc """
  The UserRepo behavior.
  """
  alias EricApi.Domain.User

  @callback list_users() :: [User.t()]
  @callback get_user!(id :: integer) :: User.t() | Ecto.NoResultsError
  @callback get_user(id :: integer) :: User.t() | nil
  @callback get_by(map()) :: User.t() | nil
  @callback create_user(map()) :: {:ok, %User{}} | {:error, Ecto.Changeset.t()}
  @callback update_user(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  @callback delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  @callback change_user(User.t(), map()) :: Ecto.Changeset.t()
end
