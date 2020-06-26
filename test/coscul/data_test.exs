defmodule Coscul.DataTest do
  use Coscul.DataCase

  alias Coscul.Data

  describe "items" do
    alias Coscul.Data.Item

    @valid_attrs %{name: "some name", stack: 1}
    @update_attrs %{name: "some updated name", stack: 1}
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

    @valid_attrs %{time: 120.5, recipe_terms: []}
    @update_attrs %{time: 456.7, recipe_terms: []}
    @invalid_attrs %{time: nil}

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture() |> Map.put(:items_recipes, [])
      assert Data.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture() |> Map.put(:items_recipes, []) |> Map.put(:items, [])
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
      recipe = recipe_fixture() |> Map.put(:items_recipes, []) |> Map.put(:items, [])
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

  describe "recipe_terms" do
    alias Coscul.Data.RecipeTerm

    @valid_attrs %{value: 42}
    @update_attrs %{value: 43}
    @invalid_attrs %{value: nil}

    def recipe_term_fixture(attrs \\ %{}) do
      {:ok, recipe_term} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_recipe_term()

      recipe_term
    end
  end

  describe "recipe_terms" do
    alias Coscul.Data.RecipeTerm

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def recipe_term_fixture(attrs \\ %{}) do
      {:ok, recipe_term} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_recipe_term()

      recipe_term
    end

    test "list_recipe_terms/0 returns all recipe_terms" do
      recipe_term = recipe_term_fixture()
      assert Data.list_recipe_terms() == [recipe_term]
    end

    test "get_recipe_term!/1 returns the recipe_term with given id" do
      recipe_term = recipe_term_fixture()
      assert Data.get_recipe_term!(recipe_term.id) == recipe_term
    end

    test "create_recipe_term/1 with valid data creates a recipe_term" do
      assert {:ok, %RecipeTerm{} = recipe_term} = Data.create_recipe_term(@valid_attrs)
    end

    test "create_recipe_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_recipe_term(@invalid_attrs)
    end

    test "update_recipe_term/2 with valid data updates the recipe_term" do
      recipe_term = recipe_term_fixture()

      assert {:ok, %RecipeTerm{} = recipe_term} =
               Data.update_recipe_term(recipe_term, @update_attrs)
    end

    test "update_recipe_term/2 with invalid data returns error changeset" do
      recipe_term = recipe_term_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_recipe_term(recipe_term, @invalid_attrs)
      assert recipe_term == Data.get_recipe_term!(recipe_term.id)
    end

    test "delete_recipe_term/1 deletes the recipe_term" do
      recipe_term = recipe_term_fixture()
      assert {:ok, %RecipeTerm{}} = Data.delete_recipe_term(recipe_term)
      assert_raise Ecto.NoResultsError, fn -> Data.get_recipe_term!(recipe_term.id) end
    end

    test "change_recipe_term/1 returns a recipe_term changeset" do
      recipe_term = recipe_term_fixture()
      assert %Ecto.Changeset{} = Data.change_recipe_term(recipe_term)
    end
  end

  describe "recipe_categories" do
    alias Coscul.Data.RecipeCategory

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def recipe_category_fixture(attrs \\ %{}) do
      {:ok, recipe_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_recipe_category()

      recipe_category
    end

    test "list_recipe_categories/0 returns all recipe_categories" do
      recipe_category = recipe_category_fixture()
      assert Data.list_recipe_categories() == [recipe_category]
    end

    test "get_recipe_category!/1 returns the recipe_category with given id" do
      recipe_category = recipe_category_fixture()
      assert Data.get_recipe_category!(recipe_category.id) == recipe_category
    end

    test "create_recipe_category/1 with valid data creates a recipe_category" do
      assert {:ok, %RecipeCategory{} = recipe_category} =
               Data.create_recipe_category(@valid_attrs)

      assert recipe_category.name == "some name"
    end

    test "create_recipe_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_recipe_category(@invalid_attrs)
    end

    test "update_recipe_category/2 with valid data updates the recipe_category" do
      recipe_category = recipe_category_fixture()

      assert {:ok, %RecipeCategory{} = recipe_category} =
               Data.update_recipe_category(recipe_category, @update_attrs)

      assert recipe_category.name == "some updated name"
    end

    test "update_recipe_category/2 with invalid data returns error changeset" do
      recipe_category = recipe_category_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Data.update_recipe_category(recipe_category, @invalid_attrs)

      assert recipe_category == Data.get_recipe_category!(recipe_category.id)
    end

    test "delete_recipe_category/1 deletes the recipe_category" do
      recipe_category = recipe_category_fixture()
      assert {:ok, %RecipeCategory{}} = Data.delete_recipe_category(recipe_category)
      assert_raise Ecto.NoResultsError, fn -> Data.get_recipe_category!(recipe_category.id) end
    end

    test "change_recipe_category/1 returns a recipe_category changeset" do
      recipe_category = recipe_category_fixture()
      assert %Ecto.Changeset{} = Data.change_recipe_category(recipe_category)
    end
  end

  describe "factories" do
    alias Coscul.Data.Factory

    @valid_attrs %{can_input_liquid: true, name: "some name"}
    @update_attrs %{can_input_liquid: false, name: "some updated name"}
    @invalid_attrs %{can_input_liquid: nil, name: nil}

    def factory_fixture(attrs \\ %{}) do
      {:ok, factory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_factory()

      factory
    end

    test "list_factories/0 returns all factories" do
      factory = factory_fixture()
      assert Data.list_factories() == [factory]
    end

    test "get_factory!/1 returns the factory with given id" do
      factory = factory_fixture()
      assert Data.get_factory!(factory.id) == factory
    end

    test "create_factory/1 with valid data creates a factory" do
      assert {:ok, %Factory{} = factory} = Data.create_factory(@valid_attrs)
      assert factory.can_input_liquid == true
      assert factory.name == "some name"
    end

    test "create_factory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_factory(@invalid_attrs)
    end

    test "update_factory/2 with valid data updates the factory" do
      factory = factory_fixture()
      assert {:ok, %Factory{} = factory} = Data.update_factory(factory, @update_attrs)
      assert factory.can_input_liquid == false
      assert factory.name == "some updated name"
    end

    test "update_factory/2 with invalid data returns error changeset" do
      factory = factory_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_factory(factory, @invalid_attrs)
      assert factory == Data.get_factory!(factory.id)
    end

    test "delete_factory/1 deletes the factory" do
      factory = factory_fixture()
      assert {:ok, %Factory{}} = Data.delete_factory(factory)
      assert_raise Ecto.NoResultsError, fn -> Data.get_factory!(factory.id) end
    end

    test "change_factory/1 returns a factory changeset" do
      factory = factory_fixture()
      assert %Ecto.Changeset{} = Data.change_factory(factory)
    end
  end
end
