defmodule Coscul.DataTest do
  use Coscul.DataCase

  alias Coscul.Data

  describe "items" do
    alias Coscul.Data.Item

    @valid_attrs %{name: "some name", stack: 1, terms: nil}
    @update_attrs %{name: "some updated name", stack: 1, terms: nil}
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
        |> Map.put(:terms, [])

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
        |> Map.put(:terms, [])

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

    test "create_recipe/1 with terms data creates a recipe and terms" do
      item = item_fixture()
      attrs_with_terms = @valid_attrs |> Enum.into(%{terms: [%{item_id: item.id, value: 1}]})

      assert {:ok, %Recipe{terms: [%Coscul.Data.Term{}]} = recipe} =
               Data.create_recipe(attrs_with_terms)
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

  describe "terms" do
    alias Coscul.Data.Term

    @valid_attrs %{value: 1}
    @update_attrs %{value: 2}

    def term_fixture(attrs \\ %{}) do
      item = item_fixture()
      recipe = recipe_fixture()

      {:ok, term} =
        attrs
        |> Enum.into(%{item_id: item.id, recipe_id: recipe.id()})
        |> Enum.into(@valid_attrs)
        |> Data.create_term()

      term
    end

    test "list_terms/0 returns all terms" do
      term = term_fixture()
      assert Data.list_terms() == [term]
    end

    test "get_term!/1 returns the term with given id" do
      term = term_fixture()
      assert Data.get_term!(term.id) == term
    end

    test "create_term/1 with valid data creates a term" do
      item = item_fixture()
      recipe = recipe_fixture()

      created_repo =
        @valid_attrs
        |> Map.merge(%{item_id: item.id, recipe_id: recipe.id})
        |> Data.create_term()

      assert {:ok, %Term{} = term} = created_repo
    end

    test "create_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_term(@invalid_attrs)
    end

    test "update_term/2 with valid data updates the term" do
      term = term_fixture()
      assert {:ok, %Term{} = term} = Data.update_term(term, @update_attrs)
    end

    test "delete_term/1 deletes the term" do
      term = term_fixture()
      assert {:ok, %Term{}} = Data.delete_term(term)
      assert_raise Ecto.NoResultsError, fn -> Data.get_term!(term.id) end
    end

    test "change_term/1 returns a term changeset" do
      term = term_fixture()
      assert %Ecto.Changeset{} = Data.change_term(term)
    end
  end
end
