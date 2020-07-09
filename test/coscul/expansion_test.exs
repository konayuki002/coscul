defmodule Coscul.ExpansionTest do
  use Coscul.DataCase

  alias Coscul.Expansion

  describe "production_lines" do
    alias Coscul.Expansion.ProductionLine

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def production_line_fixture(attrs \\ %{}) do
      {:ok, production_line} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Expansion.create_production_line()

      production_line
    end

    test "list_production_lines/0 returns all production_lines" do
      production_line = production_line_fixture()
      assert Expansion.list_production_lines() == [production_line]
    end

    test "get_production_line!/1 returns the production_line with given id" do
      production_line = production_line_fixture()
      assert Expansion.get_production_line!(production_line.id) == production_line
    end

    test "create_production_line/1 with valid data creates a production_line" do
      assert {:ok, %ProductionLine{} = production_line} = Expansion.create_production_line(@valid_attrs)
    end

    test "create_production_line/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expansion.create_production_line(@invalid_attrs)
    end

    test "update_production_line/2 with valid data updates the production_line" do
      production_line = production_line_fixture()
      assert {:ok, %ProductionLine{} = production_line} = Expansion.update_production_line(production_line, @update_attrs)
    end

    test "update_production_line/2 with invalid data returns error changeset" do
      production_line = production_line_fixture()
      assert {:error, %Ecto.Changeset{}} = Expansion.update_production_line(production_line, @invalid_attrs)
      assert production_line == Expansion.get_production_line!(production_line.id)
    end

    test "delete_production_line/1 deletes the production_line" do
      production_line = production_line_fixture()
      assert {:ok, %ProductionLine{}} = Expansion.delete_production_line(production_line)
      assert_raise Ecto.NoResultsError, fn -> Expansion.get_production_line!(production_line.id) end
    end

    test "change_production_line/1 returns a production_line changeset" do
      production_line = production_line_fixture()
      assert %Ecto.Changeset{} = Expansion.change_production_line(production_line)
    end
  end
end
