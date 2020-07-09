defmodule CosculWeb.RecipeTermControllerTest do
  use CosculWeb.ConnCase

  alias Coscul.Data

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:recipe_term) do
    {:ok, recipe_term} = Data.create_recipe_term(@create_attrs)
    recipe_term
  end

  describe "index" do
    test "lists all recipe_terms", %{conn: conn} do
      conn = get(conn, Routes.recipe_term_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Recipe terms"
    end
  end

  describe "new recipe_term" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.recipe_term_path(conn, :new))
      assert html_response(conn, 200) =~ "New Recipe term"
    end
  end

  describe "create recipe_term" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.recipe_term_path(conn, :create), recipe_term: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.recipe_term_path(conn, :show, id)

      conn = get(conn, Routes.recipe_term_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Recipe term"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.recipe_term_path(conn, :create), recipe_term: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Recipe term"
    end
  end

  describe "edit recipe_term" do
    setup [:create_recipe_term]

    test "renders form for editing chosen recipe_term", %{conn: conn, recipe_term: recipe_term} do
      conn = get(conn, Routes.recipe_term_path(conn, :edit, recipe_term))
      assert html_response(conn, 200) =~ "Edit Recipe term"
    end
  end

  describe "update recipe_term" do
    setup [:create_recipe_term]

    test "redirects when data is valid", %{conn: conn, recipe_term: recipe_term} do
      conn =
        put(conn, Routes.recipe_term_path(conn, :update, recipe_term), recipe_term: @update_attrs)

      assert redirected_to(conn) == Routes.recipe_term_path(conn, :show, recipe_term)

      conn = get(conn, Routes.recipe_term_path(conn, :show, recipe_term))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, recipe_term: recipe_term} do
      conn =
        put(conn, Routes.recipe_term_path(conn, :update, recipe_term), recipe_term: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Recipe term"
    end
  end

  describe "delete recipe_term" do
    setup [:create_recipe_term]

    test "deletes chosen recipe_term", %{conn: conn, recipe_term: recipe_term} do
      conn = delete(conn, Routes.recipe_term_path(conn, :delete, recipe_term))
      assert redirected_to(conn) == Routes.recipe_term_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.recipe_term_path(conn, :show, recipe_term))
      end
    end
  end

  defp create_recipe_term(_) do
    recipe_term = fixture(:recipe_term)
    {:ok, recipe_term: recipe_term}
  end
end
