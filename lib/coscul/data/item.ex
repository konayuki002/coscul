defmodule Coscul.Data.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coscul.Data.{InputTerm, OutputTerm}

  schema "items" do
    field :name, :string
    has_many :input_terms, InputTerm
    has_many :output_terms, OutputTerm

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
