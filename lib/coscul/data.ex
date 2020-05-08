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
    |> preload([{:recipe_terms, :item}])
    |> Repo.all()
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
    Recipe |> preload([{:recipe_terms, :item}]) |> Repo.get(id)
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
          {:ok, Recipe.t()} | {:error, Ecto.Changeset.t()}
  def create_recipe(attrs) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
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
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
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
    delete_recipe_terms(recipe.id)
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

  def update_recipe_term_list(recipe_id, %{recipe_terms: recipe_term_attrs_list}) do
    Enum.map(recipe_term_attrs_list, &upsert_recipe_term(&1))

    RecipeTerm
    |> filter_query_by_recipe_id(recipe_id)
    |> reject_query_in_attrs_list(recipe_term_attrs_list)
    |> Repo.delete_all()
  end

  defp filter_query_by_recipe_id(query, recipe_id) do
    where(query, recipe_id: ^recipe_id)
  end

  defp reject_query_in_attrs_list(query, recipe_term_attrs_list) do
    where(query, [r], not (r.id in ^fetch_id_in_map_list(recipe_term_attrs_list)))
  end

  defp fetch_id_in_map_list(map_list) do
    Enum.map(map_list, &Map.get(&1, :id))
  end

  defp upsert_recipe_term(%{id: id} = recipe_term_attrs) do
    RecipeTerm
    |> Repo.get!(id)
    |> RecipeTerm.changeset(recipe_term_attrs)
    |> Repo.update!()
  end

  defp upsert_recipe_term(attrs) do
    %RecipeTerm{}
    |> RecipeTerm.changeset(attrs)
    |> Repo.insert()
  end

  defp delete_recipe_terms(recipe_id) do
    RecipeTerm
    |> filter_query_by_recipe_id(recipe_id)
    |> Repo.delete_all()
  end
end
