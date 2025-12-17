defmodule McpBigQuery.Tools.ExecuteQuery do
  use Hermes.Server.Component, type: :tool

  schema do
    field :query, :string, required: true
  end

  alias McpBigQuery.Adapter
  alias Hermes.Server.Response

  def execute(%{query: query}, frame) do
    case Map.get(frame, :assigns) do
      %{authorized: true} ->
        {:reply, Response.json(Response.tool(), Adapter.execute_query(query)), frame}

      _else ->
        {:error, "Unauthorized"}
    end
  end
end
