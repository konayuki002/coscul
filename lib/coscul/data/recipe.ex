defmodule Coscul.Data.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{RecipeTerm, RecipeCategory}

  @type t :: %__MODULE__{
          time: float(),
          recipe_terms: list(RecipeTerm.t()),
          recipe_category: RecipeCategory.t(),
          order: integer()
        }

  schema "recipes" do
    field :time, :float
    has_many :recipe_terms, RecipeTerm
    belongs_to :recipe_category, RecipeCategory
    field :order, :integer

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:time, :recipe_category_id, :order])
    |> validate_required([:time, :recipe_category_id, :order])
  end
end
