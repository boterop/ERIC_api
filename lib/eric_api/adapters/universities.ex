defmodule EricApi.Adapters.Universities do
  @moduledoc """
  The Universities adapter.
  """
  alias EricApi.Domain.University

  @base_url "http://universities.hipolabs.com"

  @doc """
  Search universities by country.
  """
  @spec search(String.t()) :: {:ok, [University.t()]} | {:error, term()}
  def search(country) do
    url = "#{@base_url}/search?country=#{URI.encode(country)}"

    request =
      :get
      |> Finch.build(url)
      |> Finch.request(EricApi.Finch)

    case request do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        universities =
          body
          |> Jason.decode!()
          |> Enum.map(&parse_university/1)

        {:ok, universities}

      {:ok, %Finch.Response{status: status}} ->
        {:error, "HTTP request failed with status #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_university(data) do
    %University{
      name: data["name"],
      country: data["country"],
      state_province: data["state-province"],
      domains: data["domains"] || [],
      alpha_two_code: data["alpha_two_code"],
      web_pages: data["web_pages"] || []
    }
  end
end
