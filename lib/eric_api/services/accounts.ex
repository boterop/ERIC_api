defmodule EricApi.Services.Accounts do
  @moduledoc """
  accounts use case.
  """
  @behaviour EricApi.Ports.UserRepo

  alias EricApi.Adapters.Users
  @adapter Application.compile_env(:eric_api, :user_adapter, Users)

  @impl true
  def list_users, do: @adapter.list_users()
  @impl true
  def get_user!(id), do: @adapter.get_user!(id)
  @impl true
  def get_by(attrs), do: @adapter.get_by(attrs)
  @impl true
  def create_user(attrs \\ %{}), do: @adapter.create_user(attrs)
  @impl true
  def update_user(user, attrs), do: @adapter.update_user(user, attrs)
  @impl true
  def delete_user(user), do: @adapter.delete_user(user)
  @impl true
  def change_user(user, attrs \\ %{}), do: @adapter.change_user(user, attrs)
end
