defmodule CosculWeb.Api.RecipeControllerTest do
  use CosculWeb.ConnCase

  alias Coscul.Data
  alias Coscul.Data.Recipe

  @create_attrs %{
    time: 1.0
  }
  @update_attrs %{
    time: 2.0
  }
  @invalid_attrs %{time: nil}

  def fixture(:recipe) do
    {:ok, recipe} = Data.create_recipe(@create_attrs)
    item = fixture(:item)
    fixture(:input_term, item, recipe)
    fixture(:output_term, item, recipe)
    Data.get_recipe!(recipe.id)
  end

  @item_attrs %{name: "some item name", stack: 1, input_term_id: nil, output_term_id: nil}

  def fixture(:item) do
    {:ok, item} = Data.create_item(@item_attrs)
    item
  end

  @input_term_attrs %{value: 1}

  def fixture(:input_term, item, recipe) do
    {:ok, input_term} =
      @input_term_attrs
      |> Map.merge(%{item_id: item.id, recipe_id: recipe.id})
      |> Data.create_input_term()

    input_term
  end

  @output_term_attrs %{value: 1}

  def fixture(:output_term, item, recipe) do
    {:ok, output_term} =
      @output_term_attrs
      |> Enum.into(%{item_id: item.id, recipe_id: recipe.id})
      |> Data.create_output_term()

    output_term
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      conn = get(conn, Routes.api_recipe_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create recipe" do
    test "renders recipe when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_recipe_path(conn, :create), recipe: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_recipe_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_recipe_path(conn, :create), recipe: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    test "renders recipe when data is valid", %{conn: conn, recipe: %Recipe{id: id} = recipe} do
      conn = put(conn, Routes.api_recipe_path(conn, :update, recipe), recipe: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_recipe_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn = put(conn, Routes.api_recipe_path(conn, :update, recipe), recipe: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete recipe" do
    setup [:create_recipe]

    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      conn = delete(conn, Routes.api_recipe_path(conn, :delete, recipe))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_recipe_path(conn, :show, recipe))
      end
    end
  end

  defp create_recipe(_) do
    recipe = fixture(:recipe)
    {:ok, recipe: recipe}
  end
end
