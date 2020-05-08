defmodule Coscul.Data.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{Item, RecipeTerm}

  @type t :: %__MODULE__{
          time: float(),
          recipe_terms: list(RecipeTerm.t()),
          items: list(Item.t())
        }

  schema "recipes" do
    field :time, :float
    has_many :recipe_terms, RecipeTerm
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
