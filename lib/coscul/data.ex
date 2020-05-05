defmodule Coscul.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Coscul.Repo

  alias Coscul.Data.{Item, Term, Recipe}

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Item
    |> preload([:terms])
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
    Item |> preload([:terms]) |> Repo.get!(id)
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
    |> case do
      {:ok, item} -> {:ok, get_item!(item.id)}
      {:error, _} = insert_result -> insert_result
    end
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
    Term
    |> where(item_id: ^item.id)
    |> Repo.all()
    |> Enum.map(&get_recipe!(&1.recipe_id))
    |> Enum.each(&delete_recipe(&1))

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
    |> preload([:terms])
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
  def get_recipe!(id) do
    Recipe |> preload([:terms]) |> Repo.get!(id)
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
      {:ok, recipe} -> attrs |> Map.get(:terms) |> create_related_terms(recipe)
      {:error, _} = insert_result -> insert_result
    end
  end

  defp create_related_terms(nil, recipe) do
    {:ok, get_recipe!(recipe.id)}
  end

  defp create_related_terms(term_attrs, recipe) do
    term_attrs
    |> Enum.map(&Map.put_new(&1, :recipe_id, recipe.id))
    |> Enum.map(&create_term(&1))
    |> Keyword.get(:error)
    |> check_created_terms_with_rollback(recipe)
  end

  defp check_created_terms_with_rollback(nil, recipe), do: {:ok, get_recipe!(recipe.id)}

  defp check_created_terms_with_rollback(error_message, recipe) do
    delete_recipe(recipe)
    {:error, error_message}
  end

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

  alias Coscul.Data.Term

  @doc """
  Returns the list of terms.

  ## Examples

      iex> list_terms()
      [%Term{}, ...]

  """
  def list_terms do
    Repo.all(Term)
  end

  @doc """
  Gets a single term.

  Raises if the Term does not exist.

  ## Examples

      iex> get_term!(123)
      %Term{}

  """
  def get_term!(id), do: Repo.get!(Term, id)

  @doc """
  Creates a term.

  ## Examples

      iex> create_term(%{field: value})
      {:ok, %Term{}}

      iex> create_term(%{field: bad_value})
      {:error, ...}

  """
  def create_term(attrs \\ %{}) do
    %Term{}
    |> Term.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a term.

  ## Examples

      iex> update_term(term, %{field: new_value})
      {:ok, %Term{}}

      iex> update_term(term, %{field: bad_value})
      {:error, ...}

  """
  def update_term(%Term{} = term, attrs) do
    term
    |> Term.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Term.

  ## Examples

      iex> delete_term(term)
      {:ok, %Term{}}

      iex> delete_term(term)
      {:error, ...}

  """
  def delete_term(%Term{} = term) do
    Repo.delete(term)
  end

  @doc """
  Returns a data structure for tracking term changes.

  ## Examples

      iex> change_term(term)
      %Todo{...}

  """
  def change_term(%Term{} = term) do
    Term.changeset(term, %{})
  end
end
