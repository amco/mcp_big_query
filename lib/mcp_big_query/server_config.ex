defmodule McpBigQuery.ServerConfig do
  def http_port do
    Application.get_env(:mcp_big_query, :http_port) || 4000
  end

  def server_url do
    Application.get_env(:mcp_big_query, :server_url) ||
      "http://localhost:4001"
  end
end
