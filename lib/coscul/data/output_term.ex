defmodule Coscul.Data.OutputTerm do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{Item, Recipe}

  schema "output_terms" do
    field :value, :integer
    belongs_to :item, Item
    belongs_to :recipe, Recipe

    timestamps()
  end

  @doc false
  def changeset(output_term, attrs) do
    output_term
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
