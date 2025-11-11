defmodule EricApiWeb.UniversityJSON do
  alias EricApi.Domain.University

  @doc """
  Renders the list of universities.
  """
  @spec index(map()) :: map()
  def index(%{answers: answers}) do
    %{data: for(answer <- answers, do: data(answer))}
  end

  defp data(%University{} = answer) do
    %{
      name: answer.name,
      country: answer.country,
      state_province: answer.state_province,
      domains: answer.domains,
      alpha_two_code: answer.alpha_two_code,
      web_pages: answer.web_pages
    }
  end
end
