defmodule CosculWeb.Api.TermView do
  use CosculWeb, :view
  alias CosculWeb.Api.TermView

  def render("index.json", %{terms: terms}) do
    render_many(terms, TermView, "term.json")
  end

  def render("show.json", %{term: term}) do
    render_one(term, TermView, "term.json")
  end

  def render("term.json", %{term: term}) do
    %{
      id: term.id,
      value: term.value
    }
  end
end
