defmodule Coscul.Repo.Migrations.InitMigration do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :stack, :integer
      add :is_liquid, :boolean
      timestamps()
    end

    create table(:recipe_categories) do
      add :name, :string
      timestamps()
    end

    create table(:factories) do
      add :name, :string
      add :can_input_liquid, :boolean, default: false, null: false
      add :crafting_speed, :float
      add :recipe_category_id, references(:recipe_categories)
      timestamps()
    end

    create table(:recipes) do
      add :time, :float
      add :recipe_category_id, references(:recipe_categories)
      timestamps()
    end

    create table(:recipe_terms) do
      add :value, :integer
      add :item_id, references(:items)
      add :recipe_id, references(:recipes)
      timestamps()
    end

    create_if_not_exists unique_index(:recipe_terms, [:item_id, :recipe_id])
  end
end
