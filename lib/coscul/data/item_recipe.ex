defmodule Coscul.Data.ItemRecipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{Item, Recipe}

  schema "items_recipes" do
    field :value, :integer
    belongs_to :item, Item
    belongs_to :recipe, Recipe

    timestamps()
  end

  @doc false
  def changeset(item_recipe, attrs) do
    item_recipe
    |> cast(attrs, [:value, :item_id, :recipe_id])
    |> validate_required([:value, :item_id, :recipe_id])
  end
end
