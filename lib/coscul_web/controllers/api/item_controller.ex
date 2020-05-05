defmodule CosculWeb.Api.ItemController do
  use CosculWeb, :controller

  alias Coscul.Data
  alias Coscul.Data.Item

  action_fallback CosculWeb.FallbackController

  def index(conn, _params) do
    items = Data.list_items()
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"item" => item_params}) do
    with {:ok, %Item{} = item} <- Data.create_item(item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_item_path(conn, :show, item))
      |> render("show.json", item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Data.get_item!(id)
    render(conn, "show.json", item: item)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Data.get_item!(id)

    with {:ok, %Item{} = item} <- Data.update_item(item, item_params) do
      render(conn, "show.json", item: item)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Data.get_item!(id)

    with {:ok, %Item{}} <- Data.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end
end
