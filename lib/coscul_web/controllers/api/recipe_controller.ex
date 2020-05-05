defmodule CosculWeb.Api.RecipeController do
  use CosculWeb, :controller

  alias Coscul.Data
  alias Coscul.Data.Recipe

  action_fallback CosculWeb.FallbackController

  def index(conn, _params) do
    recipes = Data.list_recipes()
    render(conn, "index.json", recipes: recipes)
  end

  def create(conn, %{"recipe" => recipe_params}) do
    with {:ok, %Recipe{} = recipe} <- Data.create_recipe(recipe_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_recipe_path(conn, :show, recipe))
      |> render("show.json", recipe: recipe)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Data.get_recipe!(id)
    render(conn, "show.json", recipe: recipe)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Data.get_recipe!(id)

    with {:ok, %Recipe{} = recipe} <- Data.update_recipe(recipe, recipe_params) do
      render(conn, "show.json", recipe: recipe)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Data.get_recipe!(id)

    with {:ok, %Recipe{}} <- Data.delete_recipe(recipe) do
      send_resp(conn, :no_content, "")
    end
  end
end
