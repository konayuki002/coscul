defmodule CosculWeb.FactoryController do
  use CosculWeb, :controller

  alias Coscul.Data
  alias Coscul.Data.Factory

  def index(conn, _params) do
    factories = Data.list_factories()
    render(conn, "index.html", factories: factories)
  end

  def new(conn, _params) do
    changeset = Data.change_factory(%Factory{})
    recipe_categories = Data.list_recipe_categories()
    render(conn, "new.html", changeset: changeset, recipe_categories: recipe_categories)
  end

  def create(conn, %{"factory" => factory_params}) do
    case Data.create_factory(factory_params) do
      {:ok, factory} ->
        conn
        |> put_flash(:info, "Factory created successfully.")
        |> redirect(to: Routes.factory_path(conn, :show, factory))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    factory = Data.get_factory!(id)
    render(conn, "show.html", factory: factory)
  end

  def edit(conn, %{"id" => id}) do
    factory = Data.get_factory!(id)
    changeset = Data.change_factory(factory)
    recipe_categories = Data.list_recipe_categories()

    render(conn, "edit.html",
      factory: factory,
      changeset: changeset,
      recipe_categories: recipe_categories
    )
  end

  def update(conn, %{"id" => id, "factory" => factory_params}) do
    factory = Data.get_factory!(id)

    case Data.update_factory(factory, factory_params) do
      {:ok, factory} ->
        conn
        |> put_flash(:info, "Factory updated successfully.")
        |> redirect(to: Routes.factory_path(conn, :show, factory))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", factory: factory, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    factory = Data.get_factory!(id)
    {:ok, _factory} = Data.delete_factory(factory)

    conn
    |> put_flash(:info, "Factory deleted successfully.")
    |> redirect(to: Routes.factory_path(conn, :index))
  end
end
