defmodule Coscul.Data.Factory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.RecipeCategory

  schema "factories" do
    field :can_input_liquid, :boolean, default: false
    field :name, :string
    field :crafting_speed, :float
    belongs_to :recipe_category, RecipeCategory

    timestamps()
  end

  @doc false
  def changeset(factory, attrs) do
    factory
    |> cast(attrs, [:name, :can_input_liquid, :crafting_speed, :recipe_category_id])
    |> validate_required([:name, :can_input_liquid, :crafting_speed, :recipe_category_id])
  end
end
