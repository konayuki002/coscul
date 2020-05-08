defmodule Coscul.Data.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{Recipe, RecipeTerm}

  @type t :: %__MODULE__{
          name: String.t(),
          stack: integer(),
          recipe_terms: list(RecipeTerm.t()),
          recipes: list(Recipe.t())
        }

  schema "items" do
    field :name, :string
    field :stack, :integer
    has_many :recipe_terms, RecipeTerm
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
