defmodule EricApi.Workers.SendEmail do
  @moduledoc """
  Sends an email with the scores of the students.
  """

  use Oban.Worker,
    queue: :mailers,
    max_attempts: 5

  alias EricApi.Emails.ScoreEmail

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email, "file_path" => file_path}}) do
    result =
      email
      |> ScoreEmail.csv_ready(file_path)
      |> EricApi.Mailer.deliver()

    case result do
      {:ok, _} ->
        File.rm(file_path)
        :ok

      {:error, reason} ->
        {:error, reason}
    end
  end
end
