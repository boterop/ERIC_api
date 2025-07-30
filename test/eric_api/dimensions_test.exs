defmodule EricApi.DimensionsTest do
  use EricApi.DataCase

  alias EricApi.Services.Dimensions

  describe "answers" do
    alias EricApi.Domain.Answer

    import EricApi.DimensionsFixtures

    @invalid_attrs %{value: nil, dimension: nil}

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Dimensions.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Dimensions.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      valid_attrs = %{value: 42, dimension: :procedural}

      assert {:ok, %Answer{} = answer} = Dimensions.create_answer(valid_attrs)
      assert answer.value == 42
      assert answer.dimension == :procedural
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dimensions.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      update_attrs = %{value: 43, dimension: :emotional}

      assert {:ok, %Answer{} = answer} = Dimensions.update_answer(answer, update_attrs)
      assert answer.value == 43
      assert answer.dimension == :emotional
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Dimensions.update_answer(answer, @invalid_attrs)
      assert answer == Dimensions.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Dimensions.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Dimensions.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Dimensions.change_answer(answer)
    end
  end
end
