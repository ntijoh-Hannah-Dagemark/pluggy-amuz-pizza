defmodule Pluggy.CartController do
  require IEx

  # <-- Change 2: Update alias to Pizza
  alias Pluggy.Cart
  alias Pluggy.Pizza
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3, put_resp_cookie: 3]

  def index(conn) do
    #require IEx
    #IEx.pry()
    #|>
    send_resp(conn, 200, render("cart/index", cart: Cart.get_all_in(Map.get(conn.cookies, "cart_id")), pizzas: Pizza.all()))
  end

  def create(conn) do
    cart_id = UUID.uuid4()
    conn = put_resp_cookie(conn, "cart_id", cart_id)
    IO.inspect(cart_id, label: "Cart ID set at")
    conn
  end

  def add(conn, params) do
    conn = if not Map.has_key?(conn.cookies, "cart_id"), do: create(conn), else: conn
    if params["modifications"] != nil do
      Cart.add(Map.get(conn.cookies, "cart_id"),params["pizza_id"],params["modifications"])
    else
      Cart.add(Map.get(conn.cookies, "cart_id"),params["pizza_id"])
    end
    redirect(conn, "/pizzas")
  end

  def remove(conn, params) do
    Cart.delete(params["id"])
    redirect(conn, "/pizzas")
  end

  def checkout(conn, params) do
    Cart.delete_all(Map.get(conn.cookies, "cart_id"))
    redirect(conn, "/pizzas")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
