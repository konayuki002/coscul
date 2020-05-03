defmodule Coscul.Data.InputTerm do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{Item, Recipe}

  schema "input_terms" do
    field :value, :integer
    belongs_to :item, Item
    belongs_to :recipe, Recipe

    timestamps()
  end

  @doc false
  def changeset(input_term, attrs) do
    input_term
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
