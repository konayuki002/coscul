defmodule Coscul.Repo.Migrations.CreateInputTerms do
  use Ecto.Migration

  def change do
    create table(:input_terms) do
      add :value, :integer

      timestamps()
    end
  end
end
