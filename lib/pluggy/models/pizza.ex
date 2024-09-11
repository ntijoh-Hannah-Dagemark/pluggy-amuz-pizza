defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", toppings: "")

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT * FROM pizza", []).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM pizza WHERE id = $1 LIMIT 1", [String.to_integer(id)]
    ).rows
    |> to_struct
  end

  def update(id, params) do
    name = params["name"]
    toppings = params["toppings"]
    id = String.to_integer(id)
    Postgrex.query!(
      DB,
      "UPDATE pizza SET name = $1, toppings = $2 WHERE id = $3",
      [name, toppings, id]
    )
  end

  def create(params) do
    name = params["name"]
    toppings = params["toppings"]

    Postgrex.query!(DB, "INSERT INTO pizza (name, toppings) VALUES ($1, $2)", [name, toppings])
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM pizza WHERE id = $1", [String.to_integer(id)])
  end

  def to_struct([[id, name, toppings]]) do
    %Pizza{id: id, name: name, toppings: toppings}
  end

  def to_struct_list(rows) do
    for [id, name, toppings] <- rows, do: %Pizza{id: id, name: name, toppings: toppings}
  end
end
