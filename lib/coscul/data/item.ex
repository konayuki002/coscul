defmodule Coscul.Data.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.RecipeTerm

  @type t :: %__MODULE__{
          name: String.t(),
          stack: integer(),
          is_liquid: boolean(),
          recipe_terms: list(RecipeTerm.t())
        }

  schema "items" do
    field :name, :string
    field :stack, :integer
    field :is_liquid, :boolean
    has_many :recipe_terms, RecipeTerm

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :stack, :is_liquid])
    |> validate_required([:name, :stack, :is_liquid])
  end
end
