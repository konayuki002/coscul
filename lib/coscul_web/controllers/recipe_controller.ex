defmodule CosculWeb.RecipeController do
  use CosculWeb, :controller

  alias Coscul.Data
  alias Coscul.Data.{Recipe, RecipeTerm}

  def index(conn, _params) do
    recipes = Data.list_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Data.change_recipe(%Recipe{})
    items = Data.list_items()
    recipe_categories = Data.list_recipe_categories()
    recipe_term_changeset = RecipeTerm.changeset(%RecipeTerm{}, %{})

    render(conn, "new.html",
      changeset: changeset,
      items: items,
      recipe_term_changeset: recipe_term_changeset,
      recipe_categories: recipe_categories
    )
  end

  def create(conn, %{"recipe" => recipe_params}) do
    case Data.create_recipe(recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe created successfully.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Data.get_recipe!(id)
    render(conn, "show.html", recipe: recipe)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Data.get_recipe!(id)
    changeset = Data.change_recipe(recipe)
    items = Data.list_items()
    recipe_categories = Data.list_recipe_categories()
    recipe_term_changeset = RecipeTerm.changeset(%RecipeTerm{}, %{})

    render(conn, "edit.html",
      recipe: recipe,
      changeset: changeset,
      items: items,
      recipe_term_changeset: recipe_term_changeset,
      recipe_categories: recipe_categories
    )
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Data.get_recipe!(id)

    case Data.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe updated successfully.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe: recipe, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Data.get_recipe!(id)
    {:ok, _recipe} = Data.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: Routes.recipe_path(conn, :index))
  end
end
