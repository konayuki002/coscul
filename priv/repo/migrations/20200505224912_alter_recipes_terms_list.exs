defmodule Coscul.Repo.Migrations.AlterRecipesTermsList do
  use Ecto.Migration

  def change do
    alter table("recipes") do
      add :terms, {:array, :map}, default: []
    end
  end
end
