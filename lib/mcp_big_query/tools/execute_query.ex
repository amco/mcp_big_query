defmodule McpBigQuery.Tools.ExecuteQuery do
  use Hermes.Server.Component, type: :tool

  schema do
    field :query, :string, required: true
  end

  alias McpBigQuery.Adapter
  alias Hermes.Server.Response

  def execute(%{query: query}, frame) do
    {:reply, Response.json(Response.tool(), Adapter.execute_query(query)), frame}
  end
end
