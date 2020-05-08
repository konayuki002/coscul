defmodule Coscul.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi

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
  @spec create_recipe(map()) ::
          {:ok, Recipe.t()} | {:error, Ecto.Changeset.t()} | {:error, any(), any(), any()}
  def create_recipe(attrs) do
    Multi.new()
    |> Multi.insert(:recipe_not_associated, Recipe.changeset(%Recipe{}, attrs))
    |> update_association(attrs)
    |> update_recipe_terms_value(attrs)
    |> Repo.transaction()
  end

  defp update_association(multi, %{recipe_terms: recipe_term_attrs}) do
    multi
    |> Multi.update(:recipe_not_preloaded, fn %{recipe_not_associated: recipe} ->
      recipe
      |> Repo.preload(:items)
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(
        :items,
        fetch_items_by_recipe_term_attrs(recipe_term_attrs)
      )
    end)
    |> Multi.run(:recipe, fn _repo, %{recipe_not_preloaded: recipe} ->
      Recipe |> preload(:recipe_terms) |> Repo.get(recipe.id)
    end)
  end

  defp fetch_items_by_recipe_term_attrs(recipe_term_attrs) do
    Item
    |> where([item], item.id in ^list_item_ids_in_recipe_term_attrs(recipe_term_attrs))
    |> Repo.all()
  end

  defp list_item_ids_in_recipe_term_attrs(recipe_term_attrs) do
    Enum.map(recipe_term_attrs, &Map.get(&1, :item_id))
  end

  defp update_recipe_terms_value(multi, %{recipe_terms: recipe_terms_attrs}) do
    recipe_terms_attrs
    |> Enum.reduce(multi, fn recipe_term_attrs, multi ->
      Multi.update(multi, :recipe_term, fn %{recipe: recipe} ->
        build_recipe_term_changeset_by_recipe(recipe, recipe_term_attrs)
      end)
    end)
  end

  defp build_recipe_term_changeset_by_recipe(recipe, recipe_term_attrs) do
    recipe.recipe_terms
    |> Enum.find(fn recipe_term -> recipe_term.id == recipe_term_attrs.id end)
    |> RecipeTerm.changeset(recipe_term_attrs)
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
    Multi.new()
    |> Multi.insert(:recipe, Recipe.changeset(recipe, attrs))
    |> update_association(attrs)
    |> update_recipe_terms_value(attrs)
    |> Repo.transaction()
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
