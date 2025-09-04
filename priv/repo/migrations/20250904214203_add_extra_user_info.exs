defmodule EricApi.Repo.Migrations.AddExtraUserInfo do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :type, :string, default: "student"
      add :country, :string
      add :institution, :string
      add :age, :integer
    end
  end
end
