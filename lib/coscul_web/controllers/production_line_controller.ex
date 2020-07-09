defmodule CosculWeb.ProductionLineController do
  use CosculWeb, :controller

  alias Coscul.Expansion

  alias Coscul.Data
  alias Coscul.Data.RecipeTerm

  def expand(conn, params) do
    items_expanded = Expansion.calculate_ingredients(params)
    items = Data.list_items()
    render(conn, "expand.html", items_expanded: items_expanded, items: items)
  end

  def index(conn, _params) do
    production_lines = Expansion.list_production_lines()
    render(conn, "index.html", production_lines: production_lines)
  end

  def new(conn, _params) do
    changeset = Expansion.change_production_line(%{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"production_line" => production_line_params}) do
    case Expansion.create_production_line(production_line_params) do
      {:ok, production_line} ->
        conn
        |> put_flash(:info, "Production line created successfully.")
        |> redirect(to: Routes.production_line_path(conn, :show, production_line))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    production_line = Expansion.get_production_line!(id)
    render(conn, "show.html", production_line: production_line)
  end

  def edit(conn, %{"id" => id}) do
    production_line = Expansion.get_production_line!(id)
    changeset = Expansion.change_production_line(production_line)
    render(conn, "edit.html", production_line: production_line, changeset: changeset)
  end

  def update(conn, %{"id" => id, "production_line" => production_line_params}) do
    production_line = Expansion.get_production_line!(id)

    case Expansion.update_production_line(production_line, production_line_params) do
      {:ok, production_line} ->
        conn
        |> put_flash(:info, "Production line updated successfully.")
        |> redirect(to: Routes.production_line_path(conn, :show, production_line))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", production_line: production_line, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    production_line = Expansion.get_production_line!(id)
    {:ok, _production_line} = Expansion.delete_production_line(production_line)

    conn
    |> put_flash(:info, "Production line deleted successfully.")
    |> redirect(to: Routes.production_line_path(conn, :index))
  end
end
