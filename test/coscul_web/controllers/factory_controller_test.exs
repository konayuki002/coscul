defmodule CosculWeb.FactoryControllerTest do
  use CosculWeb.ConnCase

  alias Coscul.Data

  @create_attrs %{can_input_liquid: true, name: "some name"}
  @update_attrs %{can_input_liquid: false, name: "some updated name"}
  @invalid_attrs %{can_input_liquid: nil, name: nil}

  def fixture(:factory) do
    {:ok, factory} = Data.create_factory(@create_attrs)
    factory
  end

  describe "index" do
    test "lists all factories", %{conn: conn} do
      conn = get(conn, Routes.factory_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Factories"
    end
  end

  describe "new factory" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.factory_path(conn, :new))
      assert html_response(conn, 200) =~ "New Factory"
    end
  end

  describe "create factory" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.factory_path(conn, :create), factory: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.factory_path(conn, :show, id)

      conn = get(conn, Routes.factory_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Factory"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.factory_path(conn, :create), factory: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Factory"
    end
  end

  describe "edit factory" do
    setup [:create_factory]

    test "renders form for editing chosen factory", %{conn: conn, factory: factory} do
      conn = get(conn, Routes.factory_path(conn, :edit, factory))
      assert html_response(conn, 200) =~ "Edit Factory"
    end
  end

  describe "update factory" do
    setup [:create_factory]

    test "redirects when data is valid", %{conn: conn, factory: factory} do
      conn = put(conn, Routes.factory_path(conn, :update, factory), factory: @update_attrs)
      assert redirected_to(conn) == Routes.factory_path(conn, :show, factory)

      conn = get(conn, Routes.factory_path(conn, :show, factory))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, factory: factory} do
      conn = put(conn, Routes.factory_path(conn, :update, factory), factory: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Factory"
    end
  end

  describe "delete factory" do
    setup [:create_factory]

    test "deletes chosen factory", %{conn: conn, factory: factory} do
      conn = delete(conn, Routes.factory_path(conn, :delete, factory))
      assert redirected_to(conn) == Routes.factory_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.factory_path(conn, :show, factory))
      end
    end
  end

  defp create_factory(_) do
    factory = fixture(:factory)
    {:ok, factory: factory}
  end
end
