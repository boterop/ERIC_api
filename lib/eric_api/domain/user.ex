defmodule EricApi.Domain.User do
  @moduledoc false

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t(),
          email: String.t(),
          password: String.t()
        }

  defstruct [:id, :name, :email, :password]
end
