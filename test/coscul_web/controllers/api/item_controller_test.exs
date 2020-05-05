defmodule CosculWeb.Api.ItemControllerTest do
  use CosculWeb.ConnCase

  alias Coscul.Data
  alias Coscul.Data.Item

  @create_attrs %{name: "some name", time: 1.0, stack: 1}
  @update_attrs %{name: "some updated name", time: 2.0, stack: 2}
  @invalid_attrs %{name: nil}

  def fixture(:item) do
    {:ok, item} = Data.create_item(@create_attrs)
    recipe = fixture(:recipe)
    fixture(:input_term, item, recipe)
    fixture(:output_term, item, recipe)
    Data.get_item!(item.id)
  end

  @recipe_attrs %{time: 1.0, input_term_id: nil, output_term_id: nil}

  def fixture(:recipe) do
    {:ok, recipe} = Data.create_recipe(@recipe_attrs)
    recipe
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
    test "lists all items", %{conn: conn} do
      conn = get(conn, Routes.api_item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create item" do
    test "renders item when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_item_path(conn, :create), item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_item_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_item_path(conn, :create), item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update item" do
    setup [:create_item]

    test "renders item when data is valid", %{conn: conn, item: %Item{id: id} = item} do
      conn = put(conn, Routes.api_item_path(conn, :update, item), item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_item_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put(conn, Routes.api_item_path(conn, :update, item), item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, Routes.api_item_path(conn, :delete, item))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_item_path(conn, :show, item))
      end
    end
  end

  defp create_item(_) do
    item = fixture(:item)
    {:ok, item: item}
  end
end
