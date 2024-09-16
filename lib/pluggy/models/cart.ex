defmodule Pluggy.Cart do
  defstruct(id: nil, str_id: "", pizza_id: nil, modifications: "")

  alias Pluggy.Cart

  def get_all_in(id) do
    Postgrex.query!(DB, "SELECT * FROM pizza_prog WHERE str_id = $1", [id]).rows
    |> to_struct_list
  end

  def add(cart_id, pizza_id) do
    Postgrex.query!(
      DB,
      "INSERT INTO pizza_prog (str_id, pizza_id, modifications) VALUES ($1, $2, 'none')",
      [
        cart_id,
        pizza_id
      ]
    )
  end

  def add(cart_id, pizza_id, modifications) do
    Postgrex.query!(
        DB,
        "INSERT INTO pizza_prog (str_id, pizza_id, modifications) VALUES ($1, $2, $3)",
        [
          cart_id,
          pizza_id,
          modifications
        ]
      )
  end

  def delete(id) do
     Postgrex.query!(DB, "DELETE FROM pizza_prog WHERE id = $1", [String.to_integer(id)])
  end

  def delete_all(cart_id) do
    Postgrex.query!(DB, "DELETE FROM pizza_prog WHERE str_id = $1", [cart_id])
  end

  def to_struct_list(rows) do
    IO.inspect(rows, label: "Rows in to_struct_list")
    for [id, str_id, pizza_id, modifications ] <- rows, do: %Cart{id: id, str_id: str_id, pizza_id: pizza_id, modifications: modifications}
  end
end
