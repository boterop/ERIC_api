defmodule EricApi.Services.Universities do
  @moduledoc """
  Universities use case.
  """
  @behaviour EricApi.Ports.UniversityRepo

  alias EricApi.Adapters.Universities
  @adapter Application.compile_env(:eric_api, :university_adapter, Universities)

  @impl true
  def search(country), do: @adapter.search(country)
end
