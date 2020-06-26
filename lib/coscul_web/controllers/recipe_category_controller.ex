defmodule CosculWeb.RecipeCategoryController do
  use CosculWeb, :controller

  alias Coscul.Data
  alias Coscul.Data.RecipeCategory

  def index(conn, _params) do
    recipe_categories = Data.list_recipe_categories()
    render(conn, "index.html", recipe_categories: recipe_categories)
  end

  def new(conn, _params) do
    changeset = Data.change_recipe_category(%RecipeCategory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"recipe_category" => recipe_category_params}) do
    case Data.create_recipe_category(recipe_category_params) do
      {:ok, recipe_category} ->
        conn
        |> put_flash(:info, "Recipe category created successfully.")
        |> redirect(to: Routes.recipe_category_path(conn, :show, recipe_category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe_category = Data.get_recipe_category!(id)
    render(conn, "show.html", recipe_category: recipe_category)
  end

  def edit(conn, %{"id" => id}) do
    recipe_category = Data.get_recipe_category!(id)
    changeset = Data.change_recipe_category(recipe_category)
    render(conn, "edit.html", recipe_category: recipe_category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recipe_category" => recipe_category_params}) do
    recipe_category = Data.get_recipe_category!(id)

    case Data.update_recipe_category(recipe_category, recipe_category_params) do
      {:ok, recipe_category} ->
        conn
        |> put_flash(:info, "Recipe category updated successfully.")
        |> redirect(to: Routes.recipe_category_path(conn, :show, recipe_category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe_category: recipe_category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe_category = Data.get_recipe_category!(id)
    {:ok, _recipe_category} = Data.delete_recipe_category(recipe_category)

    conn
    |> put_flash(:info, "Recipe category deleted successfully.")
    |> redirect(to: Routes.recipe_category_path(conn, :index))
  end
end
