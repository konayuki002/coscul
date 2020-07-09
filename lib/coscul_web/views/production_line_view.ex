defmodule CosculWeb.ProductionLineView do
  use CosculWeb, :view

  def format_item_id_number(%Plug.Conn{params: %{"item_id" => item_id}}, item) do
    String.to_integer(item_id) == item.id
  end

  def format_item_id_number(_, _), do: false

  def format_required_item_value_number(%Plug.Conn{
        params: %{"required_item_value" => required_item_value}
      }) do
    {required_item_value_number, _string} = Float.parse(required_item_value)
    required_item_value_number
  end

  def format_required_item_value_number(_), do: 1.0
end
