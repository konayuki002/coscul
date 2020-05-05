defmodule CosculWeb.Api.RecipeView do
  use CosculWeb, :view
  alias CosculWeb.Api.{TermView, RecipeView}

  def render("index.json", %{recipes: recipes}) do
    %{data: render_many(recipes, RecipeView, "recipe.json")}
  end

  def render("show.json", %{recipe: recipe}) do
    %{data: render_one(recipe, RecipeView, "recipe.json")}
  end

  def render("recipe.json", %{recipe: recipe}) do
    %{
      id: recipe.id,
      time: recipe.time,
      terms: TermView.render("index.json", %{terms: recipe.terms})
    }
  end
end
