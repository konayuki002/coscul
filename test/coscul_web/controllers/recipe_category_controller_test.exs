defmodule CosculWeb.RecipeCategoryControllerTest do
  use CosculWeb.ConnCase

  alias Coscul.Data

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:recipe_category) do
    {:ok, recipe_category} = Data.create_recipe_category(@create_attrs)
    recipe_category
  end

  describe "index" do
    test "lists all recipe_categories", %{conn: conn} do
      conn = get(conn, Routes.recipe_category_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Recipe categories"
    end
  end

  describe "new recipe_category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.recipe_category_path(conn, :new))
      assert html_response(conn, 200) =~ "New Recipe category"
    end
  end

  describe "create recipe_category" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.recipe_category_path(conn, :create), recipe_category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.recipe_category_path(conn, :show, id)

      conn = get(conn, Routes.recipe_category_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Recipe category"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.recipe_category_path(conn, :create), recipe_category: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Recipe category"
    end
  end

  describe "edit recipe_category" do
    setup [:create_recipe_category]

    test "renders form for editing chosen recipe_category", %{
      conn: conn,
      recipe_category: recipe_category
    } do
      conn = get(conn, Routes.recipe_category_path(conn, :edit, recipe_category))
      assert html_response(conn, 200) =~ "Edit Recipe category"
    end
  end

  describe "update recipe_category" do
    setup [:create_recipe_category]

    test "redirects when data is valid", %{conn: conn, recipe_category: recipe_category} do
      conn =
        put(conn, Routes.recipe_category_path(conn, :update, recipe_category),
          recipe_category: @update_attrs
        )

      assert redirected_to(conn) == Routes.recipe_category_path(conn, :show, recipe_category)

      conn = get(conn, Routes.recipe_category_path(conn, :show, recipe_category))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, recipe_category: recipe_category} do
      conn =
        put(conn, Routes.recipe_category_path(conn, :update, recipe_category),
          recipe_category: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Recipe category"
    end
  end

  describe "delete recipe_category" do
    setup [:create_recipe_category]

    test "deletes chosen recipe_category", %{conn: conn, recipe_category: recipe_category} do
      conn = delete(conn, Routes.recipe_category_path(conn, :delete, recipe_category))
      assert redirected_to(conn) == Routes.recipe_category_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.recipe_category_path(conn, :show, recipe_category))
      end
    end
  end

  defp create_recipe_category(_) do
    recipe_category = fixture(:recipe_category)
    {:ok, recipe_category: recipe_category}
  end
end
