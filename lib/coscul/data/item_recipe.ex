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
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :stack])
    |> validate_required([:name, :stack])
  end
end
