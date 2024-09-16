defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run("app.start")
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizza", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizza_prog", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")
    # Add 'toppings' column instead of 'tastiness'
    Postgrex.query!(
      DB,
      """
        CREATE TABLE pizza (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          toppings VARCHAR(255) NOT NULL
        )
      """,
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      """
        CREATE TABLE pizza_prog (
          id SERIAL PRIMARY KEY,
          str_id VARCHAR(255) NOT NULL,
          pizza_id VARCHAR(255) NOT NULL,
          modifications VARCHAR(255) NOT NULL
        )
      """,
      [],
      pool: DBConnection.ConnectionPool
    )
  end

  defp seed_data() do
    IO.puts("Seeding data")
    # Inserting pizzas with name and toppings
    Postgrex.query!(
      DB,
      "INSERT INTO pizza(name, toppings) VALUES($1, $2)",
      ["Margherita", "Tomatsås, Mozzarella, Basilika"],

      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizza(name, toppings) VALUES($1, $2)",
      ["Marinara", "Tomatsås"],

      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizza(name, toppings) VALUES($1, $2)",
      ["Prosciutto e funghi", "Tomatsås, Mozzarella, Skinka, Svamp"],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizza(name, toppings) VALUES($1, $2)",
      ["Quattro stagioni", "Tomatsås, Mozzarella, Skinka, Svamp, Kronärtskocka, Oliver"],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizza(name, toppings) VALUES($1, $2)",
      ["Capricciosa", "Tomatsås, Mozzarella, Skinka, Svamp, Kronärtskocka"],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizza(name, toppings) VALUES($1, $2)",
      ["Quattro formaggi", "Tomatsås, Mozzarella, Parmesan, Pecorino, Gorgonzola"],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizza(name, toppings) VALUES($1, $2)",
      ["Ortolana", "Tomatsås, Mozzarella, Paprika, Aubergine, Zucchini"],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizza(name, toppings) VALUES($1, $2)",
      ["Diavola", "Tomatsås, Mozzarella, Salami, Paprika, Chili"],
      pool: DBConnection.ConnectionPool
    )
  end
end
