defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger

  alias Pluggy.FruitController
  alias Pluggy.UserController
  alias Pluggy.OrderController
  alias Pluggy.PizzaController
  alias Pluggy.CartController

  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base:
      "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get("/", do: PizzaController.index(conn))

  get("/cart", do: CartController.index(conn))
  post("/cart/add", do: CartController.add(conn, conn.body_params))
  post("/cart/remove", do: CartController.remove(conn, conn.body_params))
  post("/cart/checkout", do: CartController.checkout(conn, conn.body_params))

  get("/pizzas", do: PizzaController.index(conn))
  get("/pizzas/customize/:id", do: PizzaController.customize(conn, id))

  get("/orders", do: OrderController.index(conn))
  post("/orders/logon", do: OrderController.logon(conn, conn.body_params))
  post("/orders/pass_cr_frm", do: OrderController.create(conn, conn.body_params))

  # post("/users/login", do: UserController.login(conn, conn.body_params))
  # post("/users/logout", do: UserController.logout(conn))

  match _ do
    send_resp(conn, 404, "No side found")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
