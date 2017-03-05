defmodule Volition.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :gold, :integer
      add :health, :integer
      add :mana, :integer
      add :area_id, references(:areas, on_delete: :nothing)

      timestamps()
    end
    create index(:players, [:area_id])

  end
end
