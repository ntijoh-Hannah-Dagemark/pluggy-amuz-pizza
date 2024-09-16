defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", toppings: "", modifications: "")

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT * FROM pizza", []).rows
    |> to_struct_list
  end

  def all_cart do
    Postgrex.query!(DB, "SELECT * FROM pizza_prog WHERE state = $1", ["cart"]).rows
    |> IO.inspect()
    |> to_struct_list
  end

  def get(id) do
    i = id |> String.capitalize()

    Postgrex.query!(DB, "SELECT * FROM pizza WHERE name = $1 LIMIT 1", [i]).rows
    |> to_struct
  end

  def buy(id) do
    current_pizza = get(id)

    IO.inspect(current_pizza, label: "Current Pizza")

    Postgrex.query!(
      DB,
      "INSERT INTO pizza_prog (name, toppings, modifications, state) VALUES ($1, $2, $3, $4)",
      [
        current_pizza.name,
        current_pizza.toppings,
        "none",
        "cart"
      ]
    )
  end

  def buy(id, modifications) do
    current_pizza = get(id)

    Postgrex.query!(
      DB,
      "INSERT INTO pizza_prog (name, toppings, modifications, state) VALUES (?, ?, ?, ?)",
      [
        get_in(current_pizza, Access.key(:name)),
        get_in(current_pizza, Access.key(:toppings)),
        modifications,
        "cart"
      ]
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
    IO.inspect(rows, label: "Rows in to_struct_list")
    for [id, name, toppings, modifications | _state ] <- rows, do: %Pizza{id: id, name: name, toppings: toppings, modifications: modifications}
  end
end
