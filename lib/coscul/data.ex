defmodule Coscul.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Coscul.Repo

  alias Coscul.Data.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Item
    |> preload([:input_terms, :output_terms])
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
  def get_item!(id), do: Repo.get!(Item, id)

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

  alias Coscul.Data.Recipe

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Recipe
    |> preload([:input_terms, :output_terms])
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
  def get_recipe!(id), do: Repo.get!(Recipe, id)

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

  alias Coscul.Data.InputTerm

  @doc """
  Returns the list of input_terms.

  ## Examples

      iex> list_input_terms()
      [%InputTerm{}, ...]

  """
  def list_input_terms do
    Repo.all(InputTerm)
  end

  @doc """
  Gets a single input_term.

  Raises if the Input term does not exist.

  ## Examples

      iex> get_input_term!(123)
      %InputTerm{}

  """
  def get_input_term!(id), do: Repo.get!(InputTerm, id)

  @doc """
  Creates a input_term.

  ## Examples

      iex> create_input_term(%{field: value})
      {:ok, %InputTerm{}}

      iex> create_input_term(%{field: bad_value})
      {:error, ...}

  """
  def create_input_term(attrs \\ %{}) do
    %InputTerm{}
    |> InputTerm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a input_term.

  ## Examples

      iex> update_input_term(input_term, %{field: new_value})
      {:ok, %InputTerm{}}

      iex> update_input_term(input_term, %{field: bad_value})
      {:error, ...}

  """
  def update_input_term(%InputTerm{} = input_term, attrs) do
    input_term
    |> InputTerm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a InputTerm.

  ## Examples

      iex> delete_input_term(input_term)
      {:ok, %InputTerm{}}

      iex> delete_input_term(input_term)
      {:error, ...}

  """
  def delete_input_term(%InputTerm{} = input_term) do
    InputTerm.delete(input_term)
  end

  @doc """
  Returns a data structure for tracking input_term changes.

  ## Examples

      iex> change_input_term(input_term)
      %Todo{...}

  """
  def change_input_term(%InputTerm{} = input_term) do
    InputTerm.changeset(input_term, %{})
  end
end
