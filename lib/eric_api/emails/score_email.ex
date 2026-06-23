defmodule EricApi.Emails.ScoreEmail do
  @moduledoc """
  Sends an email with the scores of the students.
  """

  import Swoosh.Email

  @from System.get_env("GMAIL_USERNAME")
  @subject "Scores #{DateTime.utc_now() |> DateTime.to_string()}"

  @spec csv_ready(String.t(), String.t()) :: Swoosh.Email.t()
  def csv_ready(email, file_path) do
    new()
    |> to(email)
    |> from(@from)
    |> subject(@subject)
    |> text_body("""
      Hi,

      Here are the scores of the students.

      Best regards,
      Boterop
    """)
    |> attachment(
      Swoosh.Attachment.new(
        file_path,
        filename: "scores.csv"
      )
    )
  end
end
