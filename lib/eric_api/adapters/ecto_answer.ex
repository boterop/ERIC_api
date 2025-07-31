defmodule EricApi.Adapters.EctoAnswer do
  @moduledoc """
  Answer ecto schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "answers" do
    field :question, :integer
    field :value, :integer
    field :dimension, Ecto.Enum, values: [:procedural, :emotional, :cognitive, :critical]
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t()
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:question, :value, :dimension, :user_id])
    |> validate_required([:question, :value, :dimension, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
