defmodule Coscul.Repo.Migrations.CreateOutputTerms do
  use Ecto.Migration

  def change do
    create table(:output_terms) do
      add :value, :integer

      timestamps()
    end
  end
end
