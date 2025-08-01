defmodule EricApiWeb.AnswerJSON do
  alias EricApi.Domain.Answer

  @doc """
  Renders a list of answers.
  """
  @spec index(map()) :: map()
  def index(%{answers: answers}) do
    %{data: for(answer <- answers, do: data(answer))}
  end

  @doc """
  Renders a single answer.
  """
  @spec show(map()) :: map()
  def show(%{answer: answer}) do
    %{data: data(answer)}
  end

  defp data(%Answer{} = answer) do
    %{
      id: answer.id,
      question: answer.question,
      value: answer.value,
      dimension: answer.dimension
    }
  end
end
