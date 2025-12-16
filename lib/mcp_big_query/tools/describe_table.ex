defmodule McpBigQuery.Tools.DescribeTable do
  use Hermes.Server.Component, type: :tool

  schema do
    field :table_name, :string, required: true
  end

  alias McpBigQuery.Adapter
  alias Hermes.Server.Response

  def execute(%{table_name: name}, frame) do
    {:reply, Response.json(Response.tool(), Adapter.describe_table(name)), frame}
  end
end
