defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", toppings: "", modifications: "")

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT * FROM pizza", []).rows
    |> to_struct_list
  end

  def get(id) do
    i = id |> String.capitalize()

    Postgrex.query!(DB, "SELECT * FROM pizza WHERE name = $1 LIMIT 1", [i]).rows
    |> to_struct
  end

  def to_struct([[id, name, toppings]]) do
    %Pizza{id: id, name: name, toppings: toppings}
  end

  def to_struct_list(rows) do
    IO.inspect(rows, label: "Rows in to_struct_list")
    for [id, name, toppings] <- rows, do: %Pizza{id: id, name: name, toppings: toppings}
  end
end
