defmodule Coscul.Data.OutputTerm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "output_terms" do
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(output_term, attrs) do
    output_term
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
