defmodule McpBigQuery.Tools.ListTables do
  use Hermes.Server.Component, type: :tool

  schema do
  end

  alias McpBigQuery.Adapter
  alias Hermes.Server.Response

  def execute(%{}, frame) do
    case assigns do
      %{authorized: true} ->
        {:reply, Response.json(Response.tool(), Adapter.list_tables()), frame}

      _else ->
        {:error, "Unauthorized"}
    end
  end
end
