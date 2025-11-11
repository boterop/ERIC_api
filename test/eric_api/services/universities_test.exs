defmodule EricApi.Services.UniversitiesTest do
  use ExUnit.Case, async: true

  alias EricApi.Services.Universities
  alias EricApi.Domain.University

  describe "search/1" do
    test "returns universities for valid country" do
      assert {:ok, universities} = Universities.search("Colombia")
      assert is_list(universities)
      assert length(universities) == 2

      [first_university | _] = universities
      assert %University{} = first_university
      assert first_university.name == "Universidad Nacional de Colombia"
      assert first_university.country == "Colombia"
      assert first_university.state_province == "Bogotá"
      assert first_university.domains == ["unal.edu.co"]
      assert first_university.alpha_two_code == "CO"
      assert first_university.web_pages == ["http://www.unal.edu.co/"]
    end

    test "returns empty list for country with no universities" do
      assert {:ok, universities} = Universities.search("InvalidCountry")
      assert universities == []
    end

    test "returns error when adapter fails" do
      assert {:error, reason} = Universities.search("ErrorCountry")
      assert reason == "HTTP request failed with status 500"
    end

    test "returns empty list for unknown country" do
      assert {:ok, universities} = Universities.search("UnknownCountry")
      assert universities == []
    end
  end
end
