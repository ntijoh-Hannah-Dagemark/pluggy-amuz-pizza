defmodule Pluggy.PizzaController do
  require IEx

  # <-- Change 2: Update alias to Pizza
  alias Pluggy.Pizza
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    IO.inspect(Pizza.all(), label: "Return of Pizza.all()")
    send_resp(conn, 200, render("pizzas/index", pizzas: Pizza.all()))
  end

  def owner(conn) do
    send_resp(conn, 200, render("pizzas/owner", []))
  end

  # Render the 'new' template
  # <-- Change 5: Template name ("fruits/new" -> "pizzas/new")
  def new(conn), do: send_resp(conn, 200, render("pizza/new", []))

  def show(conn, id), do: send_resp(conn, 200, render("pizza/show", pizza: Pizza.get(id)))

  # <-- Change 6: Template name, keyword argument ("fruits/show" -> "pizzas/show", fruit: -> pizza:)

  def edit(conn, id), do: send_resp(conn, 200, render("pizza/edit", pizza: Pizza.get(id)))

  # <-- Change 7: Template name, keyword argument ("fruits/edit" -> "pizzas/edit", fruit: -> pizza:)

  def create(conn, params) do
    # <-- Change 8: Update to Pizza.create
    Pizza.create(params)

    case params["file"] do
      nil -> IO.puts("No file uploaded")
      _ -> File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
    end

    # <-- Change 9: URL path ("/fruits" -> "/pizzas")
    redirect(conn, "/pizza")
  end

  # Denna funktionen har inget att göra med "buy/1" i pizza.ex
  @spec buy(any(), binary()) :: %Pluggy.Pizza{id: any(), name: any(), toppings: any()}
  def buy(conn, id) do
    Pizza.buy(id)
    send_resp(conn, 200, render("pizzas/index", pizza: Pizza.get(id)))
  end

  def customize(conn, id) do
    send_resp(
      conn,
      200,
      render("pizzas/customize", pizza: Pizza.get(id), ingredients: Pizza.all_ingredients())
    )
  end

  def update(conn, id, params) do
    # <-- Change 10: Update to Pizza.update
    Pizza.update(id, params)
    # <-- Change 11: URL path ("/fruits" -> "/pizzas")
    redirect(conn, "/pizza")
  end

  def destroy(conn, id) do
    # <-- Change 12: Update to Pizza.delete
    Pizza.delete(id)
    # <-- Change 13: URL path ("/fruits" -> "/pizzas")
    redirect(conn, "/pizza")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
