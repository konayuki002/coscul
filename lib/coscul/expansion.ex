defmodule Coscul.Expansion do
  @moduledoc """
  The Expansion context.
  """

  import Ecto.Query, warn: false
  alias Coscul.Repo

  alias Coscul.Data
  alias Coscul.Data.{Item, RecipeTerm, Recipe}

  @doc """
  Returns the list of production_lines.

  ## Examples

      iex> list_production_lines()
      [%ProductionLine{}, ...]

  """
  def list_production_lines do
    raise "TODO"
  end

  @doc """
  Gets a single production_line.

  Raises if the Production line does not exist.

  ## Examples

      iex> get_production_line!(123)
      %ProductionLine{}

  """
  def get_production_line!(id), do: raise("TODO")

  # recipeを関数として生成してデータに突っ込む?そして関数を再帰で呼び出す. timeやfactoryは最後に掛け割り マクロだ, 再帰の末端はItemで, 自身をOutputにするものが無ければそこで終了

  def calculate_ingredients(%{"required_item_value" => required_item_value, "item_id" => item_id}) do
    {required_integer, _string} = Float.parse(required_item_value)
    do_calculate_ingredients(required_integer, String.to_integer(item_id))
  end

  def do_calculate_ingredients(required_item_value, item_id) do
    functions_calculating_ingredients =
      Data.list_items()
      |> Map.new(fn %Item{id: item_id} = item ->
        {item_id, build_calculate_ingredients_function_by_item(item)}
      end)

    Map.fetch!(functions_calculating_ingredients, item_id).(
      %{},
      required_item_value,
      functions_calculating_ingredients
    )
    |> Enum.map(fn {item_id, required_item_value} ->
      %RecipeTerm{item_id: item_id, value: required_item_value} |> Repo.preload([:item])
    end)
    |> Enum.sort_by(fn recipe_term -> recipe_term.item.order end)
  end

  def calculate_ingredients(_), do: []

  def build_calculate_ingredients_function_by_item(%Item{
        id: item_id
      }) do
    item_id
    |> get_output_recipe_term_by_item_id()
    |> case do
      %RecipeTerm{} = recipe_term ->
        build_calculate_ingredients_function_by_output_terms(recipe_term)

      nil ->
        fn accumulator, required_item_value, _functions_calculating_ingredients ->
          Map.update(accumulator, item_id, required_item_value, &(&1 + required_item_value))
        end
    end
  end

  def build_calculate_ingredients_function_by_output_terms(%RecipeTerm{
        value: output_item_value,
        item_id: item_id,
        recipe_id: recipe_id
      }) do
    input_terms =
      recipe_id
      |> Data.get_recipe!()
      |> Map.get(:recipe_terms)
      |> Enum.filter(fn %RecipeTerm{value: value} -> value < 0 end)

    fn accumulator, required_item_value, functions_calculating_ingredients ->
      accumulator =
        Map.update(accumulator, item_id, required_item_value, &(&1 + required_item_value))

      Enum.reduce(input_terms, accumulator, fn %RecipeTerm{
                                                 value: input_item_value,
                                                 item_id: item_id
                                               },
                                               inner_accumulator ->
        Map.get(
          functions_calculating_ingredients,
          item_id
        ).(
          inner_accumulator,
          -required_item_value * input_item_value / output_item_value,
          functions_calculating_ingredients
        )
      end)
    end
  end

  defp get_output_recipe_term_by_item_id(item_id) do
    RecipeTerm
    |> where([rt], rt.value > 0 and rt.item_id == ^item_id)
    |> preload([:recipe])
    |> Repo.one()
  end

  # recipeはupdateで足されることはないじゃない, 各itemは後から取って一回だけ計算するから: factoryはあるかもしれないけどvalueはない

  @doc """
  Creates a production_line.

  ## Examples

      iex> create_production_line(%{field: value})
      {:ok, %ProductionLine{}}

      iex> create_production_line(%{field: bad_value})
      {:error, ...}

  """
  def create_production_line(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a production_line.

  ## Examples

      iex> update_production_line(production_line, %{field: new_value})
      {:ok, %ProductionLine{}}

      iex> update_production_line(production_line, %{field: bad_value})
      {:error, ...}

  """
  def update_production_line(production_line, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a ProductionLine.

  ## Examples

      iex> delete_production_line(production_line)
      {:ok, %ProductionLine{}}

      iex> delete_production_line(production_line)
      {:error, ...}

  """
  def delete_production_line(production_line) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking production_line changes.

  ## Examples

      iex> change_production_line(production_line)
      %Todo{...}

  """
  def change_production_line(production_line) do
    raise "TODO"
  end

  def a do
    Matrix.new(4, 5)
  end

  def build_matrix() do
    items = Data.list_items()
    recipes = Data.list_recipes()
    n_item = length(items)
    n_recipe = length(recipes)
    matrix = Matrix.new(n_item, n_item)

    matrix =
      Data.list_recipe_terms()
      |> Enum.reduce(matrix, fn recipe_term, acc ->
        Matrix.set(acc, recipe_term.item.order, recipe_term.recipe.order, recipe_term.value)
      end)
      |> IO.inspect()
      |> Matrix.inv()
      |> IO.inspect()

    required = [[0, 0, 0, 100]] |> Matrix.transpose() |> IO.inspect()
    Matrix.mult(matrix, required)
  end
end
