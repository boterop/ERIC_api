defmodule EricApi.Domain.Score do
  @moduledoc """
  The Score domain.
  """

  alias EricApi.Domain.Dimension

  @type t :: %__MODULE__{
          id: String.t() | nil,
          value: Float.t(),
          level: :high | :medium | :low,
          dimension: Dimension.t()
        }

  defstruct [:id, :value, :level, :dimension]
end
