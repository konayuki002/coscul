defmodule Coscul.Data.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :stack, :integer

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :stack])
    |> validate_required([:name, :stack])
  end
end
