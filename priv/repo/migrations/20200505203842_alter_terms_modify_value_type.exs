defmodule Coscul.Repo.Migrations.AlterTermsModifyValueType do
  use Ecto.Migration

  def change do
    alter table("terms") do
      remove :value
      add :value, :integer
    end
  end
end
