defmodule Coscul.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :time, :float

      timestamps()
    end

  end
end
