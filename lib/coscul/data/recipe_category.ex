defmodule Coscul.Data.RecipeCategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_categories" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(recipe_category, attrs) do
    recipe_category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
