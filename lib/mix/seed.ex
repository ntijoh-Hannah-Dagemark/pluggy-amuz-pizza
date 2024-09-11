defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizza", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE pizza (id SERIAL, name VARCHAR(255) NOT NULL, tastiness INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
  end

  defp seed_data() do
    IO.puts("Seeding data")
    # Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Apple", 5], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Pear", 4], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Banana", 7], pool: DBConnection.ConnectionPool)


    Postgrex.query!(DB, "INSERT INTO pizza(name, toppings) VALUES($1, $2)", ["Margherita", "Tomatsås, Mozzarella, Basilika"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizza(name, toppings) VALUES($1, $2)", ["Marinara", "Tomatsås"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizza(name, toppings) VALUES($1, $2)", ["Diavola", "Tomatsås, Mozzaerlla, Salami, Paprika, Chili "], pool: DBConnection.ConnectionPool)
  end

end
