defmodule McpBigQuery.Tools.ListTables do
  use Hermes.Server.Component, type: :tool

  schema do
  end

  alias McpBigQuery.Adapter
  alias Hermes.Server.Response

  def execute(%{}, frame) do
    {:reply, Response.json(Response.tool(), Adapter.list_tables()), frame}
  end
end
