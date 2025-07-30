defmodule EricApi.Domain.Answer do
  @moduledoc """
  The Answer domain.
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          question: integer,
          value: integer,
          dimension: :procedural | :emotional | :cognitive | :critical,
          user_id: String.t()
        }

  defstruct [:id, :question, :value, :dimension, :user_id]
end
