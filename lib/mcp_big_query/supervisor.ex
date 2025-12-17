defmodule McpBigQuery.Supervisor do
  use Supervisor

  alias McpBigQuery.{ServerConfig, GothConfig}

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children =
      [
        Hermes.Server.Registry,
        {McpBigQuery.Server, transport: {:streamable_http, base_url: ServerConfig.server_url()}},
        {Bandit, plug: McpBigQuery.Router, port: ServerConfig.http_port()}
      ] ++ GothConfig.child_spec()

    Supervisor.init(children, strategy: :one_for_one)
  end
end
