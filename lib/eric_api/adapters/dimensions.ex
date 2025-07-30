defmodule EricApi.Adapters.Dimensions do
  @moduledoc """
  The Dimensions context.
  """

  @behaviour EricApi.Ports.AnswerRepo

  import Ecto.Query, warn: false
  alias EricApi.Domain.Answer
  alias EricApi.Repo

  alias EricApi.Adapters.EctoAnswer

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers()
      [%Answer{}, ...]

  """
  @impl true
  def list_answers do
    EctoAnswer
    |> Repo.all()
    |> cast_list()
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  @impl true
  def get_answer!(id) do
    EctoAnswer
    |> Repo.get!(id)
    |> cast()
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the answer does not exist.

  ## Examples

      iex> get_by(question: 1)
      %Answer{}

      iex> get_by(question: 999999999)
      nil

  """
  @impl true
  def get_by(attrs) do
    EctoUser
    |> Repo.get_by(attrs)
    |> cast()
  end

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def create_answer(attrs \\ %{}) do
    %EctoAnswer{}
    |> EctoAnswer.changeset(attrs)
    |> Repo.insert()
    |> cast()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> EctoAnswer.changeset(attrs)
    |> Repo.update()
    |> cast()
  end

  @doc """
  Deletes a answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def delete_answer(%Answer{} = answer) do
    answer
    |> Repo.delete()
    |> cast()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{data: %Answer{}}

  """
  @impl true
  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    answer
    |> to_schema()
    |> EctoAnswer.changeset(attrs)
  end

  defp cast(%EctoAnswer{} = answer) do
    %Answer{
      id: answer.id,
      question: answer.question,
      value: answer.value,
      dimension: answer.dimension,
      user_id: answer.user_id
    }
  end

  defp cast({:ok, %EctoAnswer{} = answer}), do: {:ok, cast(answer)}

  defp cast(attrs), do: attrs

  defp cast_list([]), do: []
  defp cast_list([%EctoAnswer{} = answer | rest]), do: [cast(answer) | cast_list(rest)]
  defp cast_list(attrs), do: attrs

  defp to_schema(%Answer{} = answer) do
    %EctoAnswer{
      id: answer.id,
      question: answer.question,
      value: answer.value,
      dimension: answer.dimension,
      user_id: answer.user_id
    }
  end
end
