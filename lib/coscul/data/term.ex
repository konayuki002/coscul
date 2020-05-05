defmodule Coscul.Data.Term do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{Item, Recipe}

  schema "terms" do
    field :value, :integer
    belongs_to :item, Item
    belongs_to :recipe, Recipe

    timestamps()
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [:value, :item_id, :recipe_id])
    |> validate_required([:value, :item_id, :recipe_id])
  end
end
