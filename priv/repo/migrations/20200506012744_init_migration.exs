defmodule Coscul.Repo.Migrations.InitMigration do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:items) do
      add :name, :string
      add :stack, :integer
      timestamps()
    end

    create_if_not_exists table(:recipes) do
      add :time, :float
      timestamps()
    end

    create_if_not_exists table(:items_recipes) do
      add :item_id, references(:items)
      add :recipe_id, references(:recipes)
      add :value, :integer
      timestamps()
    end

    create_if_not_exists unique_index(:items_recipes, [:item_id, :recipe_id, :value])
  end

  def down do
    drop_if_exists table(:items)

    drop_if_exists table(:recipes)

    drop_if_exists table(:items_recipes)
  end
end
