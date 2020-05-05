defmodule CosculWeb.Api.OutputTermView do
  use CosculWeb, :view
  alias CosculWeb.Api.OutputTermView

  def render("index.json", %{output_terms: output_terms}) do
    render_many(output_terms, OutputTermView, "output_term.json")
  end

  def render("show.json", %{output_term: output_term}) do
    render_one(output_term, OutputTermView, "output_term.json")
  end

  def render("output_term.json", %{output_term: output_term}) do
    %{
      id: output_term.id,
      value: output_term.value
    }
  end
end
