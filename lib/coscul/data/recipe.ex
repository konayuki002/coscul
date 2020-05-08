defmodule Coscul.Data.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{RecipeTerm}

  @type t :: %__MODULE__{
          time: float(),
          recipe_terms: list(RecipeTerm.t())
        }

  schema "recipes" do
    field :time, :float
    has_many :recipe_terms, RecipeTerm

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:time])
    |> validate_required([:time])
  end
end
