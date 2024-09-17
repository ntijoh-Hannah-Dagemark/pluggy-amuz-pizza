defmodule Pluggy.Cart do
  defstruct(id: nil, str_id: "", pizza_id: nil, modifications: "")

  alias Pluggy.Cart

  def get_all_in(id) do
    Postgrex.query!(DB, "SELECT * FROM pizza_prog WHERE str_id = $1", [id]).rows
    |> to_struct_list
  end

  def add(cart_id, pizza_id, modifications \\ "none") do
    mod = if modifications != "none", do: modifications |> Enum.map(&String.trim/1) |> Enum.join(", "), else: modifications
    if cart_id != nil and pizza_id != nil do
      Postgrex.query!(
        DB,
        "INSERT INTO pizza_prog (str_id, pizza_id, modifications) VALUES ($1, $2, $3)",
        [
          cart_id,
          pizza_id,
          mod
        ]
      )
      IO.puts("Inserted pizza #{pizza_id} into cart #{cart_id}.\n")
      IO.inspect(get_all_in(cart_id), label: "For this cart, there are now pizzas:")
    else
      IO.puts("Failed to add pizza, values:")
      IO.inspect(cart_id, label: "Cart ID")
      IO.inspect(pizza_id, label: "Pizza ID")
    end
  end

  def delete(id) do
     Postgrex.query!(DB, "DELETE FROM pizza_prog WHERE id = $1", [String.to_integer(id)])
  end

  def delete_all(cart_id) do
    orders = get_all_in(cart_id)
    for order <- orders do
      Postgrex.query!(DB, "INSERT INTO orders (pizza_id, modifications) VALUES ($1, $2)", [order.pizza_id, order.modifications])
    end
    Postgrex.query!(DB, "DELETE FROM pizza_prog WHERE str_id = $1", [cart_id])
  end

  def to_struct_list(rows) do
    IO.inspect(rows, label: "Rows in to_struct_list")
    for [id, str_id, pizza_id, modifications ] <- rows, do: %Cart{id: id, str_id: str_id, pizza_id: pizza_id, modifications: modifications}
  end
end
