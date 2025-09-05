defmodule EricApi.Domain.User do
  @moduledoc false

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t(),
          email: String.t(),
          password: String.t(),
          type: :student | :professor,
          country: String.t(),
          institution: String.t(),
          age: integer()
        }

  defstruct [:id, :name, :email, :password, :type, :country, :institution, :age]
end
