defmodule EricApi.DimensionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EricApi.Dimensions` context.
  """

  import EricApi.AccountsFixtures
  alias EricApi.Domain.Answer
  alias EricApi.Services.Dimensions

  @doc """
  Generate a answer.
  """
  @spec answer_fixture(map()) :: Answer.t()
  def answer_fixture(attrs \\ %{}) do
    {:ok, answer} =
      attrs
      |> Enum.into(%{
        question: 1,
        dimension: :procedural,
        value: 42,
        user_id: user_fixture().id
      })
      |> Dimensions.create_answer()

    answer
  end
end
