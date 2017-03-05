defmodule Volition.Repo.Migrations.CreateNearby do
  use Ecto.Migration

  def change do
    create table(:nearbys) do
      add :area_id, references(:areas, on_delete: :nothing), primary_key: true
      add :nearby_id, references(:areas, on_delete: :nothing), primary_key: true

      timestamps()
    end
    create index(:nearbys, [:area_id])

  end
end
