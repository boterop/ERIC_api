defmodule EricApi.Domain.University do
  @moduledoc """
  The University schema.
  """

  @type t :: %__MODULE__{
          name: String.t(),
          country: String.t(),
          state_province: String.t() | nil,
          domains: [String.t()],
          alpha_two_code: String.t(),
          web_pages: [String.t()]
        }

  defstruct [:name, :country, :state_province, :domains, :alpha_two_code, :web_pages]
end
