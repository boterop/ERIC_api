defmodule EricApi.Ports.AnswerRepo do
  @moduledoc """
  The AnswerRepo behavior.
  """
  alias EricApi.Domain.Answer

  @callback list_answers() :: [Answer.t()]
  @callback get_answer!(id :: integer) :: Answer.t() | Ecto.NoResultsError
  @callback get_by(map()) :: Answer.t() | nil
  @callback get_all_by(map()) :: [Answer.t()]
  @callback create_answer(map()) :: {:ok, %Answer{}} | {:error, Ecto.Changeset.t()}
  @callback update_answer(Answer.t(), map()) :: {:ok, Answer.t()} | {:error, Ecto.Changeset.t()}
  @callback delete_answer(Answer.t()) :: {:ok, Answer.t()} | {:error, Ecto.Changeset.t()}
  @callback change_answer(Answer.t(), map()) :: Ecto.Changeset.t()
end
