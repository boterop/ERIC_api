defmodule EricApi.Ports.UniversityRepo do
  @moduledoc """
  The University behavior.
  """

  alias EricApi.Domain.University

  @callback search(String.t()) :: {:ok, [University.t()]} | {:error, term()}
end
