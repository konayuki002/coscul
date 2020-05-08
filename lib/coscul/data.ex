defmodule Coscul.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Coscul.Repo

  alias Coscul.Data.{Item, RecipeTerm, Recipe}

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  @spec list_items() :: list(Item.t())
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
  @spec get_item!(integer()) :: Item.t() | nil
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
  @spec create_item(map()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
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
  @spec update_item(Item.t(), map()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
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
  @spec delete_item(Item.t()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{source: %Item{}}

  """
  @spec change_item(Item.t()) :: Ecto.Changeset.t()
  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  @spec list_recipes() :: list(Recipe.t())
  def list_recipes do
    Recipe
    |> preload([:recipe_terms])
    |> Repo.all()
    |> Enum.map(&load_items_in_recipe/1)
  end

  defp load_items_in_recipe(nil), do: nil

  defp load_items_in_recipe(recipe) do
    Map.put(recipe, :recipe_terms, load_items_in_recipe_terms(recipe))
  end

  defp load_items_in_recipe_terms(recipe) do
    recipe |> Map.get(:recipe_terms) |> Enum.map(&Repo.preload(&1, :item))
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
  @spec get_recipe(integer()) :: Recipe.t() | nil
  def get_recipe(id) do
    Recipe |> preload([:recipe_terms]) |> Repo.get(id) |> load_items_in_recipe()
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_recipe(map()) :: {:ok, Recipe.t()} | {:error, Ecto.Changeset.t()}
  def create_recipe(attrs) do
    Repo.transaction(fn ->
      recipe =
        %Recipe{}
        |> Recipe.changeset(attrs)
        |> Repo.insert!()
        |> update_association!(attrs)
        |> update_recipe_terms_value!(attrs)

      recipe
    end)
  end

  defp update_association!(recipe, %{recipe_terms: recipe_term_attrs}) do
    recipe
    |> Repo.preload(:items)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(
      :items,
      fetch_items_by_recipe_term_attrs(recipe_term_attrs)
    )
    |> Repo.update!()
  end

  defp fetch_items_by_recipe_term_attrs(recipe_term_attrs) do
    Item
    |> where([item], item.id in ^list_item_ids_in_recipe_term_attrs(recipe_term_attrs))
    |> Repo.all()
  end

  defp list_item_ids_in_recipe_term_attrs(recipe_term_attrs) do
    Enum.map(recipe_term_attrs, &Map.get(&1, :item_id))
  end

  defp update_recipe_terms_value!(recipe, %{recipe_terms: recipe_term_attrs}) do
    recipe_term_attrs
    |> list_item_ids_in_recipe_term_attrs()
    |> Enum.map(fn item_id ->
      update_recipe_term!(
        get_recipe_term!(recipe, item_id),
        fetch_recipe_term_attrs_by_id(recipe_term_attrs, item_id)
      )
    end)
  end

  defp fetch_recipe_term_attrs_by_id(recipe_terms, id) do
    Enum.find(recipe_terms, &(id == &1.item_id))
  end

  defp get_recipe_term!(recipe, item_id) do
    RecipeTerm
    |> where(recipe_id: ^recipe.id, item_id: ^item_id)
    |> Repo.one!()
  end

  defp update_recipe_term!(%RecipeTerm{} = recipe_term, attrs) do
    recipe_term
    |> RecipeTerm.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_recipe(Recipe.t(), map()) :: {:ok, Recipe.t()} | {:error, Ecto.Changeset.t()}
  def update_recipe(%Recipe{} = recipe, attrs) do
    Repo.transaction(fn ->
      recipe
      |> Recipe.changeset(attrs)
      |> Repo.update!()
      |> update_association!(attrs)
      |> update_recipe_terms_value!(attrs)
    end)
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_recipe(Recipe.t()) :: {:ok, Recipe.t()} | {:error, Ecto.Changeset.t()}
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{source: %Recipe{}}

  """
  @spec change_recipe(Recipe.t()) :: Ecto.Changeset.t()
  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end
end
