defmodule CosculWeb.ProductionLineControllerTest do
  use CosculWeb.ConnCase

  alias Coscul.Expansion

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:production_line) do
    {:ok, production_line} = Expansion.create_production_line(@create_attrs)
    production_line
  end

  describe "index" do
    test "lists all production_lines", %{conn: conn} do
      conn = get(conn, Routes.production_line_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Production lines"
    end
  end

  describe "new production_line" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.production_line_path(conn, :new))
      assert html_response(conn, 200) =~ "New Production line"
    end
  end

  describe "create production_line" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.production_line_path(conn, :create), production_line: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.production_line_path(conn, :show, id)

      conn = get(conn, Routes.production_line_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Production line"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.production_line_path(conn, :create), production_line: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Production line"
    end
  end

  describe "edit production_line" do
    setup [:create_production_line]

    test "renders form for editing chosen production_line", %{conn: conn, production_line: production_line} do
      conn = get(conn, Routes.production_line_path(conn, :edit, production_line))
      assert html_response(conn, 200) =~ "Edit Production line"
    end
  end

  describe "update production_line" do
    setup [:create_production_line]

    test "redirects when data is valid", %{conn: conn, production_line: production_line} do
      conn = put(conn, Routes.production_line_path(conn, :update, production_line), production_line: @update_attrs)
      assert redirected_to(conn) == Routes.production_line_path(conn, :show, production_line)

      conn = get(conn, Routes.production_line_path(conn, :show, production_line))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, production_line: production_line} do
      conn = put(conn, Routes.production_line_path(conn, :update, production_line), production_line: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Production line"
    end
  end

  describe "delete production_line" do
    setup [:create_production_line]

    test "deletes chosen production_line", %{conn: conn, production_line: production_line} do
      conn = delete(conn, Routes.production_line_path(conn, :delete, production_line))
      assert redirected_to(conn) == Routes.production_line_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.production_line_path(conn, :show, production_line))
      end
    end
  end

  defp create_production_line(_) do
    production_line = fixture(:production_line)
    {:ok, production_line: production_line}
  end
end
