defmodule Coscul.Data.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{ItemRecipe, Recipe}

  schema "items" do
    field :name, :string
    field :stack, :integer
    has_many :items_recipes, ItemRecipe
    many_to_many :recipes, Recipe, join_through: "items_recipes"

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :stack])
    |> validate_required([:name, :stack])
  end
end
