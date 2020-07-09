defmodule CosculWeb.RecipeTermController do
  use CosculWeb, :controller

  alias Coscul.Data
  alias Coscul.Data.RecipeTerm

  def index(conn, _params) do
    recipe_terms = Data.list_recipe_terms()
    render(conn, "index.html", recipe_terms: recipe_terms)
  end

  def new(conn, %{"recipe_id" => recipe_id} = params) do
    changeset = Data.change_recipe_term(%RecipeTerm{recipe_id: String.to_integer(recipe_id)})
    items = Data.list_items()
    recipes = Data.list_recipes()
    render(conn, "new.html", changeset: changeset, items: items, recipes: recipes)
  end

  def create(conn, %{"recipe_term" => recipe_term_params}) do
    case Data.create_recipe_term(recipe_term_params) do
      {:ok, recipe_term} ->
        conn
        |> put_flash(:info, "Recipe term created successfully.")
        |> redirect(to: Routes.recipe_path(conn, :edit, Data.get_recipe!(recipe_term.recipe_id)))

      {:error, %Ecto.Changeset{} = changeset} ->
        items = Data.list_items()
        recipes = Data.list_recipes()
        render(conn, "new.html", changeset: changeset, items: items, recipes: recipes)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe_term = Data.get_recipe_term!(id)
    render(conn, "show.html", recipe_term: recipe_term)
  end

  def edit(conn, %{"id" => id}) do
    recipe_term = Data.get_recipe_term!(id)
    changeset = Data.change_recipe_term(recipe_term)
    items = Data.list_items()
    recipes = Data.list_recipes()

    render(conn, "edit.html",
      recipe_term: recipe_term,
      changeset: changeset,
      items: items,
      recipes: recipes
    )
  end

  def update(conn, %{"id" => id, "recipe_term" => recipe_term_params}) do
    recipe_term = Data.get_recipe_term!(id)

    case Data.update_recipe_term(recipe_term, recipe_term_params) do
      {:ok, recipe_term} ->
        conn
        |> put_flash(:info, "Recipe term updated successfully.")
        |> redirect(to: Routes.recipe_path(conn, :edit, Data.get_recipe!(recipe_term.recipe_id)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe_term: recipe_term, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe_term = Data.get_recipe_term!(id)
    {:ok, recipe_term} = Data.delete_recipe_term(recipe_term)

    conn
    |> put_flash(:info, "Recipe term deleted successfully.")
    |> redirect(to: Routes.recipe_path(conn, :edit, Data.get_recipe!(recipe_term.recipe_id)))
  end
end
