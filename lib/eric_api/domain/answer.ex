defmodule EricApi.Domain.Answer do
  @moduledoc """
  The Answer domain.
  """

  alias EricApi.Domain.Dimension

  @type t :: %__MODULE__{
          id: String.t() | nil,
          question: integer,
          value: integer,
          dimension: Dimension.t(),
          user_id: String.t()
        }

  defstruct [:id, :question, :value, :dimension, :user_id]
end
