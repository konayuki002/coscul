defmodule Coscul.Data.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{InputTerm, OutputTerm}

  schema "recipes" do
    field :time, :float
    has_many :input_terms, InputTerm
    has_many :output_terms, OutputTerm

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:time])
    |> validate_required([:time])
  end
end
