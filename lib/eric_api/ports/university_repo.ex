defmodule EricApi.Ports.UniversityRepo do
  @moduledoc """
  The University behavior.
  """
  alias EricApi.Domain.University

  @callback search(country: String.t())) :: [University.t()]
end
