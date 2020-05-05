defmodule Coscul.Data.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.Term

  schema "recipes" do
    field :time, :float
    has_many :terms, Term

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:time])
    |> validate_required([:time])
  end
end
