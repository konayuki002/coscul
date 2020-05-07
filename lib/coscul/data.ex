defmodule Coscul.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Coscul.Repo

  alias Coscul.Data.{Item, ItemRecipe, Recipe}

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Item
    |> Repo.all()
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id) do
    Repo.get!(Item, id)
  end

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{source: %Item{}}

  """
  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Recipe
    |> preload([:items_recipes])
    |> Repo.all()
    |> Enum.map(&load_items_in_recipe/1)
  end

  defp load_items_in_recipe(recipe) do
    Map.put(recipe, :items_recipes, load_items_in_items_recipes(recipe))
  end

  defp load_items_in_items_recipes(recipe) do
    recipe |> Map.get(:items_recipes) |> Enum.map(&Repo.preload(&1, :item))
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id) do
    Recipe |> preload([:items_recipes]) |> Repo.get!(id) |> load_items_in_recipe()
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, recipe} -> update_association(recipe, attrs)
      {:error, _} = error_result -> error_result
    end
  end

  defp update_association(recipe, attrs) do
    recipe
    |> Repo.preload(:items)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(
      :items,
      attrs |> list_item_ids_in_attrs |> fetch_items_in_terms()
    )
    |> Repo.update()
    |> case do
      {:ok, recipe} -> update_terms_value(recipe, attrs)
      {:error, _} = error_result -> error_result
    end
  end

  defp fetch_items_in_terms(ids) do
    Item |> where([item], item.id in ^ids) |> Repo.all()
  end

  defp update_terms_value(recipe, attrs) do
    attrs
    |> list_item_ids_in_attrs()
    |> Enum.map(fn id ->
      id |> get_item_recipe!() |> update_item_recipe(fetch_term_by_id(attrs.terms, id))
    end)
    |> Keyword.get(:error)
    |> build_update_terms_result(recipe)
  end

  defp build_update_terms_result(nil, recipe) do
    {:ok, recipe}
  end

  defp build_update_terms_result(error, _recipe) do
    {:error, error}
  end

  defp fetch_term_by_id(terms, id) do
    Enum.find(terms, &(id == &1.item_id))
  end

  defp get_item_recipe!(id) do
    Repo.get!(ItemRecipe, id)
  end

  defp update_item_recipe(%ItemRecipe{} = item_recipe, attrs) do
    item_recipe
    |> ItemRecipe.changeset(attrs)
    |> Repo.update()
  end

  defp list_item_ids_in_attrs(%{terms: terms}) do
    Enum.map(terms, &Map.get(&1, :item_id))
  end

  defp list_item_ids_in_attrs(_), do: []

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, recipe} -> update_association(recipe, attrs)
      {:error, _} = error_result -> error_result
    end
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{source: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end
end
