defmodule CosculWeb.Api.InputTermView do
  use CosculWeb, :view
  alias CosculWeb.Api.InputTermView

  def render("index.json", %{input_terms: input_terms}) do
    render_many(input_terms, InputTermView, "input_term.json")
  end

  def render("show.json", %{input_term: input_term}) do
    render_one(input_term, InputTermView, "input_term.json")
  end

  def render("input_term.json", %{input_term: input_term}) do
    %{
      id: input_term.id,
      value: input_term.value
    }
  end
end
