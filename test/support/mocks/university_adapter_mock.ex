defmodule EricApi.Mocks.UniversityAdapterMock do
  @moduledoc """
  Mock adapter for Universities for testing.
  """
  @behaviour EricApi.Ports.UniversityRepo

  alias EricApi.Domain.University

  @impl true
  def search("Colombia") do
    {:ok,
     [
       %University{
         name: "Universidad Nacional de Colombia",
         country: "Colombia",
         state_province: "Bogotá",
         domains: ["unal.edu.co"],
         alpha_two_code: "CO",
         web_pages: ["http://www.unal.edu.co/"]
       },
       %University{
         name: "Universidad de los Andes",
         country: "Colombia",
         state_province: "Bogotá",
         domains: ["uniandes.edu.co"],
         alpha_two_code: "CO",
         web_pages: ["http://www.uniandes.edu.co/"]
       }
     ]}
  end

  def search("InvalidCountry") do
    {:ok, []}
  end

  def search("ErrorCountry") do
    {:error, "HTTP request failed with status 500"}
  end

  def search(_country) do
    {:ok, []}
  end
end
