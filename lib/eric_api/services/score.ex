defmodule EricApi.Services.Score do
  @moduledoc """
  The Score use case.
  """

  @behaviour EricApi.Ports.ScoreRepo

  @adapter Application.compile_env(:eric_api, :score_adapter, EricApi.Adapters.Score)

  @impl true
  def calculate(answers, dimension \\ nil), do: @adapter.calculate(answers, dimension)
end
