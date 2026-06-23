defmodule EricApi.Ports.ScoreRepo do
  @moduledoc """
  The ScoreRepo behavior.
  """

  alias EricApi.Domain.{Answer, Dimension, Score}

  @callback calculate(answers :: [Answer.t()], dimension :: Dimension.t() | nil) :: [Score.t()]
end
