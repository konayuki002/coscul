defmodule Coscul.Data.RecipeTerm do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{Item, Recipe}

  @type t :: %__MODULE__{
          value: integer(),
          item: Item.t(),
          recipe: Recipe.t()
        }

  schema "recipe_terms" do
    field :value, :integer
    belongs_to :item, Item
    belongs_to :recipe, Recipe

    timestamps()
  end

  @doc false
  def changeset(recipe_term, attrs) do
    recipe_term
    |> cast(attrs, [:value, :item_id, :recipe_id])
    |> validate_required([:value, :item_id, :recipe_id])
  end
end
