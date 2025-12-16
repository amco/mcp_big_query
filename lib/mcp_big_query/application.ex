defmodule McpBigQuery.Application do
  use Application

  def start(_type, _args) do
    children = [
      Hermes.Server.Registry,
      {McpBigQuery.Server, transport: {:streamable_http, base_url: "http://localhost:4022"}},
      {Bandit, plug: McpBigQuery.Router, port: System.get_env("PORT") || 4000}
    ] ++ goth()

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp goth do
    credentials =
      Application.get_env(:goth, :keyfile)
      |> File.read!()
      |> Jason.decode!()

    [
      {Goth,
        name: McpBigQuery.Goth,
        source: {:service_account, credentials, [scopes: ["https://www.googleapis.com/auth/cloud-platform"]]}
      }
    ]
  end
end
