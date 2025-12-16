defmodule McpBigQuery.Adapter do
  alias GoogleApi.BigQuery.V2.Api.Tables
  alias GoogleApi.BigQuery.V2.Api.Jobs
  alias GoogleApi.BigQuery.V2.Connection
  alias GoogleApi.BigQuery.V2.Model.QueryRequest

  defp conn do
    {:ok, token} = Goth.fetch(McpBigQuery.Goth)
    Connection.new(token.token)
  end

  def list_tables do
    {:ok, resp} =
      Tables.bigquery_tables_list(conn(), project_id(), dataset())

    resp.tables
    |> Enum.map(& &1.tableReference.tableId)
  end

  def describe_table(table) do
    {:ok, resp} =
      Tables.bigquery_tables_get(conn(), project_id(), dataset(), table)

    resp.schema.fields
    |> Enum.map(fn f ->
      %{
        name: f.name,
        type: f.type,
        mode: f.mode
      }
    end)
  end

  def execute_query(sql) do
    validate_sql!(sql)

    request = %QueryRequest{
      query: sql,
      useLegacySql: false
    }

    {:ok, resp} =
      Jobs.bigquery_jobs_query(conn(), project_id(), body: request)

    rows =
      resp.rows || []

    fields =
      resp.schema.fields

    Enum.map(rows, fn row ->
      Enum.zip(fields, row.f)
      |> Enum.into(%{}, fn {field, cell} ->
        {field.name, cell.v}
      end)
    end)
  end

  defp validate_sql!(sql) do
    forbidden =
      ~r/\b(DELETE|UPDATE|INSERT|MERGE|DROP|ALTER)\b/i

    if Regex.match?(forbidden, sql) do
      raise "Only SELECT queries are allowed"
    end
  end

  defp project_id do
    Application.get(:mcp_big_query, :project_id)
  end

  defp dataset do
    Application.get(:mcp_big_query, :dataset)
  end
end
