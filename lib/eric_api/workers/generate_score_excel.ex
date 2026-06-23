defmodule EricApi.Workers.GenerateScoreExcel do
  @moduledoc """
  Generates an excel with the scores of the students.
  """

  use Oban.Worker,
    queue: :mailers,
    max_attempts: 3,
    unique: [fields: [:args], period: {5, :minutes}, keys: [:professor_id]]

  alias EricApi.Domain.{Answer, Score, User}
  alias EricApi.Services.{Accounts, Dimensions}
  alias EricApi.Services.Score, as: ScoreService

  @csv_path "priv/static/downloads"

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"professor_id" => id}}) do
    file_path = "#{@csv_path}/#{id}.csv"
    File.rm_rf!(file_path)

    csv_content =
      Accounts.list_students()
      |> Enum.sort_by(fn %User{name: name} -> name end)
      |> Enum.map(fn student ->
        student
        |> list_answers()
        |> get_score(student)
        |> create_csv_info(student)
      end)
      |> csv_encode()
      |> create_csv_headers()

    File.mkdir_p!(@csv_path)
    File.write(file_path, csv_content)

    :ok
  end

  @spec create_csv_headers(csv :: String.t()) :: String.t()
  defp create_csv_headers(csv) do
    "Name,Email,Type,Country,Institution,Age,Cognitive Score,Cognitive Level,Critical Score,Critical Level,Emotional Score,Emotional Level,Procedural Score,Procedural Level\n" <>
      csv
  end

  @spec csv_encode(csv_info :: [String.t()]) :: String.t()
  defp csv_encode(csv_info) do
    Enum.map_join(csv_info, "\n", fn row -> Enum.map_join(row, ",", &to_string/1) end)
  end

  @spec create_csv_info(score_list :: [Score.t()], student :: User.t()) :: [String.t()]
  defp create_csv_info(score_list, student) do
    cognitive = score_list |> Enum.find(fn %Score{dimension: dim} -> dim == :cognitive end)
    critical = score_list |> Enum.find(fn %Score{dimension: dim} -> dim == :critical end)
    emotional = score_list |> Enum.find(fn %Score{dimension: dim} -> dim == :emotional end)
    procedural = score_list |> Enum.find(fn %Score{dimension: dim} -> dim == :procedural end)

    [
      student.name,
      student.email,
      student.type,
      student.country,
      student.institution,
      student.age,
      cognitive.value,
      cognitive.level,
      critical.value,
      critical.level,
      emotional.value,
      emotional.level,
      procedural.value,
      procedural.level
    ]
  end

  @spec list_answers(student :: User.t()) :: [Answer.t()]
  defp list_answers(student) do
    [:cognitive, :critical, :emotional, :procedural]
    |> Enum.map(&Dimensions.get_all_by(user_id: student.id, dimension: &1))
    |> List.flatten()
  end

  @spec get_score(answers :: [Answer.t()], student :: User.t()) :: [Score.t()]
  defp get_score(answers, student) do
    answers
    |> Enum.filter(fn %Answer{user_id: user_id} -> user_id == student.id end)
    |> ScoreService.calculate()
  end
end
