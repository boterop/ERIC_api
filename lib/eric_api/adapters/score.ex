defmodule EricApi.Adapters.Score do
  @moduledoc """
  The Score context.
  """

  @behaviour EricApi.Ports.ScoreRepo
  alias EricApi.Domain.{Answer, Dimension, Score}

  @inverted_answers [
    procedural: [1, 2, 9],
    emotional: [2, 3, 9]
  ]

  @size [
    cognitive: 14,
    critical: 11,
    emotional: 15,
    procedural: 13
  ]

  @doc """
  Returns the list of scores.

  ## Examples

      iex> calculate([%Answer{}, ...], nil)
      [%Score{}, ...]

      iex> calculate([%Answer{}, ...], :emotional)
      [%Score{dimension: :emotional}, ...]

      iex> calculate([%Answer{}, ...], :invalid_dimension)
      []

  """
  @impl true
  def calculate(answers, dimension \\ nil)

  def calculate([], _dimension), do: []

  def calculate(answers, nil) do
    [:procedural, :emotional, :cognitive, :critical]
    |> Enum.map(&calculate(answers, &1))
    |> List.flatten()
  end

  def calculate(answers, dimension) do
    size = @size |> Keyword.get(dimension, 1)
    result = sum(answers, dimension) / size
    [%Score{value: result, level: get_level(result), dimension: dimension}]
  end

  @spec get_level(value :: float()) :: :high | :medium | :low
  defp get_level(value) when value <= 3.28, do: :low
  defp get_level(value) when value <= 4.08, do: :medium
  defp get_level(_value), do: :high

  @spec invert(value :: integer()) :: integer()
  defp invert(value), do: 5 - (value - 1)

  @spec sum(answers :: [Answer.t()], dimension :: Dimension.t() | nil) :: integer()
  defp sum(answers, dimension \\ nil)
  defp sum([], _dimension), do: 0

  defp sum([%Answer{value: value, dimension: dim} | rest], nil) do
    is_inverted? =
      @inverted_answers
      |> Keyword.get(dim, [])
      |> Enum.member?(value)

    result =
      case is_inverted? do
        true ->
          invert(value)

        false ->
          value
      end

    result + sum(rest)
  end

  defp sum(answers, dimension) when not is_nil(dimension) do
    answers
    |> Enum.filter(fn %Answer{dimension: dim} -> dim == dimension end)
    |> sum()
  end
end
