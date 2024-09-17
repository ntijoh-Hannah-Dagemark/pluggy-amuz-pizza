# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :pluggy,
  db: [
    pool: DBConnection.ConnectionPool,
    pool_size: 4,
    # or address
    host: "localhost",
    database: "postgres",
    username: "postgres",
    password: "docker"
  ]

config :plug, :session,
  key: "_pluggy_key",
  signing_salt: "U5rP0vS9c3A1mZ4u6HcN2i5K8V6F9gH7zB5G7fH8A6W9P2R1Q",
  encryption_salt: "4FhT8Vc9G7U3O6p2F6k5J7F2E9xB8Q1z6w8R0L4T7V1D2X9K",
  encrypt: true

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :pluggy, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:pluggy, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
