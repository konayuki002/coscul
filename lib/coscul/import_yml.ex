defmodule Coscul.ImportYml do
  import Ecto.Query, warn: false
  alias Coscul.Repo

  alias Coscul.Data
  alias Coscul.Data.RecipeCategory
  alias Coscul.Data.Item

  def insert_rows_from_yml(yml_path) do
    yml_map =
      yml_path
      |> YamlElixir.read_from_file!()

    insert_items(yml_map)
    insert_recipe_categories(yml_map)
    insert_factories(yml_map)
    insert_recipes(yml_map)
  end

  def insert_items(yml_map) do
    yml_map
    |> Map.get("items")
    |> Enum.map(fn item_attrs ->
      item_attrs
      |> Enum.map(&convert_name_to_id_if_key_is_or_atom_if_not/1)
      |> Enum.into(%{})
      |> Coscul.Data.create_item()
    end)
  end

  def insert_recipe_categories(yml_map) do
    yml_map
    |> Map.get("recipe_categories")
    |> Enum.map(fn recipe_category_attrs ->
      recipe_category_attrs
      |> Enum.map(&convert_name_to_id_if_key_is_or_atom_if_not/1)
      |> Enum.into(%{})
      |> Data.create_recipe_category()
    end)
  end

  def insert_factories(yml_map) do
    yml_map
    |> Map.get("factories")
    |> Enum.map(fn factory_attrs ->
      factory_attrs
      |> Enum.map(&convert_name_to_id_if_key_is_or_atom_if_not/1)
      |> Enum.into(%{})
      |> Coscul.Data.create_factory()
    end)
  end

  def convert_name_to_id_if_key_is_or_atom_if_not({"recipe_category", name}) do
    recipe_category_id =
      RecipeCategory
      |> where(name: ^name)
      |> Repo.one!()
      |> Map.get(:id)

    {:recipe_category_id, recipe_category_id}
  end

  def convert_name_to_id_if_key_is_or_atom_if_not(%{"item" => name, "value" => value}) do
    item_id =
      Item
      |> where(name: ^name)
      |> Repo.one!()
      |> Map.get(:id)

    %{item_id: item_id, value: value}
  end

  def convert_name_to_id_if_key_is_or_atom_if_not({key, value}) do
    {String.to_atom(key), value}
  end

  def insert_recipes(yml_map) do
    yml_map
    |> Map.get("recipes")
    |> Enum.map(fn recipe_attrs ->
      recipe_attrs =
        recipe_attrs
        |> Enum.map(&convert_name_to_id_if_key_is_or_atom_if_not/1)
        |> Enum.into(%{})

      {:ok, %{id: recipe_id}} = recipe_attrs |> Coscul.Data.create_recipe()

      recipe_attrs
      |> Map.get(:recipe_terms)
      |> Enum.map(fn recipe_term ->
        recipe_term
        |> convert_name_to_id_if_key_is_or_atom_if_not()
        |> Enum.into(%{recipe_id: recipe_id})
        |> Coscul.Data.create_recipe_term()
      end)
    end)
  end
end
