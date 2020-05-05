defmodule CosculWeb.Api.ItemView do
  use CosculWeb, :view
  alias CosculWeb.Api.{ItemView, TermView}

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
      stack: item.stack,
      terms: TermView.render("index.json", %{terms: item.terms})
    }
  end
end
