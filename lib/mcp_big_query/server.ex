defmodule McpBigQuery.Server do
  use Hermes.Server,
    name: "BigQuery Server",
    version: "1.0.0",
    protocol_version: "2025-03-26",
    capabilities: [:tools]

  component McpBigQuery.Tools.ListTables
  component McpBigQuery.Tools.DescribeTable
  component McpBigQuery.Tools.ExecuteQuery

  def init(_arg, frame) do
    headers = frame.transport[:req_headers]

    case List.keyfind(headers, "x-api-key", 0) do
      {_, api_key} when is_binary(api_key) and byte_size(api_key) > 0 ->
        case authenticate_api_key(api_key) do
          true -> {:ok, Map.put(frame, :assigns, %{authorized: true})}
          _ -> {:stop, :unauthorized}
        end

      _ ->
        {:stop, :unauthorized}
    end
  end

  defp authenticate_api_key(key) do
    api_key = Application.get_env(:mcp_big_query, :api_key)
    api_key == key
  end
end

