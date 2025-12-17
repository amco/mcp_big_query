defmodule McpBigQuery.Tools.DescribeTable do
  use Hermes.Server.Component, type: :tool

  schema do
    field(:table_name, :string, required: true)
  end

  alias McpBigQuery.Adapter
  alias Hermes.Server.Response

  def execute(%{table_name: name}, frame) do
    case Map.get(frame, :assigns) do
      %{authorized: true} ->
        {:reply, Response.json(Response.tool(), Adapter.describe_table(name)), frame}

      _else ->
        {:error, "Unauthorized"}
    end
  end
end
