defmodule Coscul.Data.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :time, :float

    embeds_many :terms, Term do
      field :value, :integer
      field :item_id, :integer
    end

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:time])
    |> cast_embed(:terms, with: &child_changeset/2)
    |> validate_required([:time])
  end

  defp child_changeset(schema, params) do
    schema
    |> cast(params, [:value, :item_id])
  end
end
