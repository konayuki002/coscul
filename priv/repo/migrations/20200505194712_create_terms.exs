defmodule Coscul.Repo.Migrations.CreateTerms do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :value, :string
      add :item_id, references(:items, on_delete: :delete_all)
      add :recipe_id, references(:recipes, on_delete: :delete_all)

      timestamps()
    end

    create index(:terms, [:item_id])
    create index(:terms, [:recipe_id])
  end
end
