defmodule Coscul.Data.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{Item, ItemRecipe}

  schema "recipes" do
    field :time, :float
    has_many :items_recipes, ItemRecipe
    many_to_many :items, Item, join_through: "items_recipes"

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:time])
    |> validate_required([:time])
  end
end
