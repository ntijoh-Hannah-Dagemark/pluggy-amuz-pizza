defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", toppings: "")

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT * FROM pizza", []).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM pizza WHERE name = $1 LIMIT 1", [id]).rows
    |> to_struct
  end

  def buy(id) do
    current_pizza = get(id)

    Postgrex.query!(
      DB,
      "INSERT INTO pizza_prog (name, toppings, modifications, state) VALUES (?, ?, ?, ?)",
      [current_pizza["name"], current_pizza["toppings"], "none", "cart"]
    )
  end

  def buy(id, modifications) do
    current_pizza = get(id)

    Postgrex.query!(
      DB,
      "INSERT INTO pizza_prog (name, toppings, modifications, state) VALUES (?, ?, ?, ?)",
      [current_pizza["name"], current_pizza["toppings"], modifications, "cart"]
    )
  end

  # def create(params) do
  #   name = params["name"]
  #   toppings = params["toppings"]
  #   Postgrex.query!(DB, "INSERT INTO pizza (name, toppings) VALUES ($1, $2)", [name, toppings])
  # end

  # def delete(id) do
  #   Postgrex.query!(DB, "DELETE FROM pizza WHERE id = $1", [String.to_integer(id)])
  # end

  def to_struct([[id, name, toppings]]) do
    %Pizza{id: id, name: name, toppings: toppings}
  end

  def to_struct_list(rows) do
    for [id, name, toppings] <- rows, do: %Pizza{id: id, name: name, toppings: toppings}
  end
end
