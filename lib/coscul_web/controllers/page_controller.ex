defmodule CosculWeb.PageController do
  use CosculWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
