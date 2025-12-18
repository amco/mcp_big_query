defmodule McpBigQuery.Application do
  use Application

  alias McpBigQuery.{ServerConfig, GothConfig}

  def start(_type, _args) do
    children =
      [
        Hermes.Server.Registry,
        {McpBigQuery.Server, transport: {:streamable_http, base_url: ServerConfig.server_url()}}
      ] ++ GothConfig.child_spec() ++ http_server()

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp http_server do
    if Application.get_env(:mcp_big_query, :start, true) do
      [{Bandit, plug: McpBigQuery.Router, port: ServerConfig.http_port()}]
    else
      []
    end
  end
end
