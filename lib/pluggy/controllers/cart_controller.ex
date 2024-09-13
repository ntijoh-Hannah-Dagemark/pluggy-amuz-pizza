defmodule Pluggy.CartController do
  require IEx

  # <-- Change 2: Update alias to Pizza
  alias Pluggy.Cart
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    #require IEx
    #IEx.pry()
    #|>
    send_resp(conn, 200, render("cart/index", cart: Cart.get_all_in(Map.get(conn.cookies, "cart_id"))))
  end

  def create(conn) do
    Map.put(conn.cookies, "cart_id", UUID.uuid4())
  end

  def add(conn, params) do
    if not Map.has_key?(conn.cookies, "cart_id"), do: create(conn)
    Cart.add(Map.get(conn.cookies, "cart_id"),params["pizza_id"])
    redirect(conn, "/pizza")
  end

  def remove(conn, id) do
    Cart.delete(id)
    redirect(conn, "/pizza")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
