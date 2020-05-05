defmodule CosculWeb.Api.ItemView do
  use CosculWeb, :view
  alias CosculWeb.Api.ItemView

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{
      id: item.id,
      name: item.name,
      input_terms: item.input_terms,
      output_terms: item.output_terms
    }
  end
end
