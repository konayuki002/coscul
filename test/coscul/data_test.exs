defmodule Coscul.DataTest do
  use Coscul.DataCase

  alias Coscul.Data

  describe "items" do
    alias Coscul.Data.Item

    @valid_attrs %{name: "some name", stack: 1, input_terms: nil, output_terms: nil}
    @update_attrs %{name: "some updated name", stack: 1, input_terms: nil, output_terms: nil}
    @invalid_attrs %{name: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()

      item =
        item
        |> Map.put(:input_terms, [])
        |> Map.put(:output_terms, [])

      assert Data.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Data.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Data.create_item(@valid_attrs)
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Data.update_item(item, @update_attrs)
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_item(item, @invalid_attrs)
      assert item == Data.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Data.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Data.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Data.change_item(item)
    end
  end

  describe "recipes" do
    alias Coscul.Data.Recipe

    @valid_attrs %{time: 120.5}
    @update_attrs %{time: 456.7}
    @invalid_attrs %{time: nil}

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()

      recipe =
        recipe
        |> Map.put(:input_terms, [])
        |> Map.put(:output_terms, [])

      assert Data.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Data.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Data.create_recipe(@valid_attrs)
      assert recipe.time == 120.5
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{} = recipe} = Data.update_recipe(recipe, @update_attrs)
      assert recipe.time == 456.7
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_recipe(recipe, @invalid_attrs)
      assert recipe == Data.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Data.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Data.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Data.change_recipe(recipe)
    end
  end

  describe "input_terms" do
    alias Coscul.Data.InputTerm

    @valid_attrs %{value: 1}
    @update_attrs %{value: 2}

    def input_term_fixture(attrs \\ %{}) do
      item = item_fixture()

      {:ok, input_term} =
        attrs
        |> Enum.into(%{item_id: item.id})
        |> Enum.into(@valid_attrs)
        |> Data.create_input_term()

      input_term
    end

    test "list_input_terms/0 returns all input_terms" do
      input_term = input_term_fixture()
      assert Data.list_input_terms() == [input_term]
    end

    test "get_input_term!/1 returns the input_term with given id" do
      input_term = input_term_fixture()
      assert Data.get_input_term!(input_term.id) == input_term
    end

    test "create_input_term/1 with valid data creates a input_term" do
      assert {:ok, %InputTerm{} = input_term} = Data.create_input_term(@valid_attrs)
    end

    test "create_input_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_input_term(@invalid_attrs)
    end

    test "update_input_term/2 with valid data updates the input_term" do
      input_term = input_term_fixture()
      assert {:ok, %InputTerm{} = input_term} = Data.update_input_term(input_term, @update_attrs)
    end

    test "delete_input_term/1 deletes the input_term" do
      input_term = input_term_fixture()
      assert {:ok, %InputTerm{}} = Data.delete_input_term(input_term)
      assert_raise Ecto.NoResultsError, fn -> Data.get_input_term!(input_term.id) end
    end

    test "change_input_term/1 returns a input_term changeset" do
      input_term = input_term_fixture()
      assert %Ecto.Changeset{} = Data.change_input_term(input_term)
    end
  end

  describe "output_terms" do
    alias Coscul.Data.OutputTerm

    @valid_attrs %{value: 1}
    @update_attrs %{value: 2}

    def output_term_fixture(attrs \\ %{}) do
      item = item_fixture()

      {:ok, output_term} =
        attrs
        |> Enum.into(%{item_id: item.id})
        |> Enum.into(@valid_attrs)
        |> Data.create_output_term()

      output_term
    end

    test "list_output_terms/0 returns all output_terms" do
      output_term = output_term_fixture()
      assert Data.list_output_terms() == [output_term]
    end

    test "get_output_term!/1 returns the output_term with given id" do
      output_term = output_term_fixture()
      assert Data.get_output_term!(output_term.id) == output_term
    end

    test "create_output_term/1 with valid data creates a output_term" do
      assert {:ok, %OutputTerm{} = output_term} = Data.create_output_term(@valid_attrs)
    end

    test "create_output_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_output_term(@invalid_attrs)
    end

    test "update_output_term/2 with valid data updates the output_term" do
      output_term = output_term_fixture()

      assert {:ok, %OutputTerm{} = output_term} =
               Data.update_output_term(output_term, @update_attrs)
    end

    test "delete_output_term/1 deletes the output_term" do
      output_term = output_term_fixture()
      assert {:ok, %OutputTerm{}} = Data.delete_output_term(output_term)
      assert_raise Ecto.NoResultsError, fn -> Data.get_output_term!(output_term.id) end
    end

    test "change_output_term/1 returns a output_term changeset" do
      output_term = output_term_fixture()
      assert %Ecto.Changeset{} = Data.change_output_term(output_term)
    end
  end
end
