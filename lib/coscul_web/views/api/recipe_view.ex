defmodule CosculWeb.Api.RecipeView do
  use CosculWeb, :view
  alias CosculWeb.Api.{InputTermView, OutputTermView, RecipeView}

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
      input_terms: InputTermView.render("index.json", %{input_terms: recipe.input_terms}),
      output_terms: OutputTermView.render("index.json", %{output_terms: recipe.output_terms})
    }
  end
end
