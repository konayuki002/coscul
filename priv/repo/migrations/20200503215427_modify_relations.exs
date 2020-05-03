defmodule Coscul.Repo.Migrations.ModifyRelations do
  use Ecto.Migration

  def change do
    alter table(:input_terms) do
      add :item_id, references(:items)
      add :recipe_id, references(:recipes)
    end

    alter table(:output_terms) do
      add :item_id, references(:items)
      add :recipe_id, references(:recipes)
    end

    alter table(:items) do
      add :stack, :integer
    end
  end
end
