defmodule Coscul.Data.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :time, :float

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:time])
    |> validate_required([:time])
  end
end
