defmodule McpBigQuery.Router do
  use Plug.Router

  alias McpBigQuery.Server

  plug(Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  forward("/mcp", to: Hermes.Server.Transport.StreamableHTTP.Plug, init_opts: [server: Server])
end
