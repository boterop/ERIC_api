defmodule EricApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EricApi.Accounts` context.
  """

  alias EricApi.Domain.User
  alias EricApi.Services.Accounts

  @doc """
  Generate a user.
  """
  @spec user_fixture(map) :: User.t()
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: Ecto.UUID.generate(),
        name: "some name",
        password: "some password",
        type: :student,
        country: "some country",
        institution: "some institution",
        age: 42
      })
      |> Accounts.create_user()

    user
  end
end
