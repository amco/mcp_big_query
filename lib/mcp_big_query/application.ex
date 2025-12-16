defmodule McpBigQuery.Application do
  use Application

  def start(_type, _args) do
    children = [
      Hermes.Server.Registry,
      {McpBigQuery.Server, transport: {:streamable_http, base_url: server_url()}},
      {Bandit, plug: McpBigQuery.Router, port: http_port()}
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

  defp http_port do
    Application.get_env(:mcp_big_query, :http_port) || 4000
  end

  defp server_url do
    Application.get_env(:mcp_big_query, :server_url) ||
      "http://localhost:4001"
  end
end
