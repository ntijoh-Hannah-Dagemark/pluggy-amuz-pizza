defmodule Pluggy.PizzaController do   # <-- Change 1: Update module name
  require IEx

  alias Pluggy.Pizza                  # <-- Change 2: Update alias to Pizza
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    send_resp(conn, 200, render("pizza/index", pizzas: Pizza.all()))
    # <-- Change 3: Update template ("fruits/index" -> "pizzas/index")
    # <-- Change 4: Update keyword argument (fruits: -> pizzas:)
    # <-- Removed all user-related functionality
  end

  # Render the 'new' template
  def new(conn), do: send_resp(conn, 200, render("pizza/new", []))  # <-- Change 5: Template name ("fruits/new" -> "pizzas/new")

  def show(conn, id), do: send_resp(conn, 200, render("pizza/show", pizza: Pizza.get(id)))
  # <-- Change 6: Template name, keyword argument ("fruits/show" -> "pizzas/show", fruit: -> pizza:)

  def edit(conn, id), do: send_resp(conn, 200, render("pizza/edit", pizza: Pizza.get(id)))
  # <-- Change 7: Template name, keyword argument ("fruits/edit" -> "pizzas/edit", fruit: -> pizza:)

  def create(conn, params) do
    Pizza.create(params)  # <-- Change 8: Update to Pizza.create
    case params["file"] do
      nil -> IO.puts("No file uploaded")
      _ -> File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
    end
    redirect(conn, "/pizza")  # <-- Change 9: URL path ("/fruits" -> "/pizzas")
  end


  def buy(conn, id) do
    Pizza.get(id)
  end


  def update(conn, id, params) do
    Pizza.update(id, params)  # <-- Change 10: Update to Pizza.update
    redirect(conn, "/pizza")  # <-- Change 11: URL path ("/fruits" -> "/pizzas")
  end

  def destroy(conn, id) do
    Pizza.delete(id)  # <-- Change 12: Update to Pizza.delete
    redirect(conn, "/pizza")  # <-- Change 13: URL path ("/fruits" -> "/pizzas")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
