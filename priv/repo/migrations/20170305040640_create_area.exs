defmodule Volition.Repo.Migrations.CreateArea do
  use Ecto.Migration

  def change do
    create table(:areas) do
      add :name, :string
      add :description, :string
      add :history, :string

      timestamps()
    end

    create unique_index(:areas, [:name])
  end
end
