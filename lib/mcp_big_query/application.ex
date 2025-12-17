defmodule McpBigQuery.Application do
  use Application

  alias McpBigQuery.{ServerConfig, GothConfig}

  def start(_type, _args) do
    children =
      [
        Hermes.Server.Registry,
        {McpBigQuery.Server, transport: {:streamable_http, base_url: ServerConfig.server_url()}},
        {Bandit, plug: McpBigQuery.Router, port: ServerConfig.http_port()}
      ] ++ GothConfig.child_spec()

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
