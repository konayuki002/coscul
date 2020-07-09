defmodule Coscul.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false

  alias Coscul.Repo
  alias Coscul.Data.{Item, RecipeTerm, Recipe, RecipeCategory, Factory}

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  @spec list_items() :: list(Item.t())
  def list_items do
    Item
    |> order_by(:order)
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
    |> preload([{:recipe_terms, ^order_recipe_term_by_item_order}, :recipe_category])
    |> order_by(:order)
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
  @spec get_recipe!(integer()) :: Recipe.t()
  def get_recipe!(id) do
    Recipe
    |> preload([{:recipe_terms, ^order_recipe_term_by_item_order}, :recipe_category])
    |> Repo.get!(id)
  end

  defp order_recipe_term_by_item_order() do
    RecipeTerm
    |> join(:left, [r], i in assoc(r, :item))
    |> order_by([r, i], asc: i.order)
    |> preload([:item])
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
    |> Repo.update()
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

  alias Coscul.Data.RecipeTerm

  @doc """
  Returns the list of recipe_terms.

  ## Examples

      iex> list_recipe_terms()
      [%RecipeTerm{}, ...]

  """
  def list_recipe_terms do
    RecipeTerm
    |> preload([:item, :recipe])
    |> Repo.all()
  end

  @doc """
  Gets a single recipe_term.

  Raises if the Recipe term does not exist.

  ## Examples

      iex> get_recipe_term!(123)
      %RecipeTerm{}

  """
  def get_recipe_term!(id) do
    RecipeTerm
    |> preload([:item, :recipe])
    |> Repo.get!(id)
  end

  @doc """
  Creates a recipe_term.

  ## Examples

      iex> create_recipe_term(%{field: value})
      {:ok, %RecipeTerm{}}

      iex> create_recipe_term(%{field: bad_value})
      {:error, ...}

  """
  def create_recipe_term(attrs \\ %{}) do
    %RecipeTerm{}
    |> RecipeTerm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe_term.

  ## Examples

      iex> update_recipe_term(recipe_term, %{field: new_value})
      {:ok, %RecipeTerm{}}

      iex> update_recipe_term(recipe_term, %{field: bad_value})
      {:error, ...}

  """
  def update_recipe_term(%RecipeTerm{} = recipe_term, attrs) do
    recipe_term
    |> RecipeTerm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a RecipeTerm.

  ## Examples

      iex> delete_recipe_term(recipe_term)
      {:ok, %RecipeTerm{}}

      iex> delete_recipe_term(recipe_term)
      {:error, ...}

  """
  def delete_recipe_term(%RecipeTerm{} = recipe_term) do
    Repo.delete(recipe_term)
  end

  @doc """
  Returns a data structure for tracking recipe_term changes.

  ## Examples

      iex> change_recipe_term(recipe_term)
      %Todo{...}

  """
  def change_recipe_term(%RecipeTerm{} = recipe_term) do
    RecipeTerm.changeset(recipe_term, %{})
  end

  alias Coscul.Data.RecipeCategory

  @doc """
  Returns the list of recipe_categories.

  ## Examples

      iex> list_recipe_categories()
      [%RecipeCategory{}, ...]

  """
  def list_recipe_categories do
    Repo.all(RecipeCategory)
  end

  @doc """
  Gets a single recipe_category.

  Raises `Ecto.NoResultsError` if the Recipe category does not exist.

  ## Examples

      iex> get_recipe_category!(123)
      %RecipeCategory{}

      iex> get_recipe_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe_category!(id), do: Repo.get!(RecipeCategory, id)

  @doc """
  Creates a recipe_category.

  ## Examples

      iex> create_recipe_category(%{field: value})
      {:ok, %RecipeCategory{}}

      iex> create_recipe_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe_category(attrs \\ %{}) do
    %RecipeCategory{}
    |> RecipeCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe_category.

  ## Examples

      iex> update_recipe_category(recipe_category, %{field: new_value})
      {:ok, %RecipeCategory{}}

      iex> update_recipe_category(recipe_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe_category(%RecipeCategory{} = recipe_category, attrs) do
    recipe_category
    |> RecipeCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe_category.

  ## Examples

      iex> delete_recipe_category(recipe_category)
      {:ok, %RecipeCategory{}}

      iex> delete_recipe_category(recipe_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe_category(%RecipeCategory{} = recipe_category) do
    Repo.delete(recipe_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe_category changes.

  ## Examples

      iex> change_recipe_category(recipe_category)
      %Ecto.Changeset{source: %RecipeCategory{}}

  """
  def change_recipe_category(%RecipeCategory{} = recipe_category) do
    RecipeCategory.changeset(recipe_category, %{})
  end

  alias Coscul.Data.Factory

  @doc """
  Returns the list of factories.

  ## Examples

      iex> list_factories()
      [%Factory{}, ...]

  """
  def list_factories do
    Factory
    |> preload([:recipe_category])
    |> Repo.all()
  end

  @doc """
  Gets a single factory.

  Raises `Ecto.NoResultsError` if the Factory does not exist.

  ## Examples

      iex> get_factory!(123)
      %Factory{}

      iex> get_factory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_factory!(id) do
    Factory
    |> preload([:recipe_category])
    |> Repo.get!(id)
  end

  @doc """
  Creates a factory.

  ## Examples

      iex> create_factory(%{field: value})
      {:ok, %Factory{}}

      iex> create_factory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_factory(attrs \\ %{}) do
    %Factory{}
    |> Factory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a factory.

  ## Examples

      iex> update_factory(factory, %{field: new_value})
      {:ok, %Factory{}}

      iex> update_factory(factory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_factory(%Factory{} = factory, attrs) do
    factory
    |> Factory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a factory.

  ## Examples

      iex> delete_factory(factory)
      {:ok, %Factory{}}

      iex> delete_factory(factory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_factory(%Factory{} = factory) do
    Repo.delete(factory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking factory changes.

  ## Examples

      iex> change_factory(factory)
      %Ecto.Changeset{source: %Factory{}}

  """
  def change_factory(%Factory{} = factory) do
    Factory.changeset(factory, %{})
  end
end
