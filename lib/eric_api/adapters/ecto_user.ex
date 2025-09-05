defmodule EricApi.Adapters.EctoUser do
  @moduledoc """
  User ecto schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :password, :string
    field :email, :string
    field :type, Ecto.Enum, values: [:student, :professor]
    field :country, :string
    field :institution, :string
    field :age, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :type, :country, :institution, :age])
    |> validate_required([:name, :email, :password, :type, :country, :institution, :age])
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
