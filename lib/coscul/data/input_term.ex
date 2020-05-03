defmodule Coscul.Data.InputTerm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "input_terms" do
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(input_term, attrs) do
    input_term
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
