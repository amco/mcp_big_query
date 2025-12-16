defmodule McpBigQuery.Adapter do
  alias GoogleApi.BigQuery.V2.Api.Tables
  alias GoogleApi.BigQuery.V2.Api.Jobs
  alias GoogleApi.BigQuery.V2.Connection
  alias GoogleApi.BigQuery.V2.Model.QueryRequest

  @project "amco-devops-training"
  @dataset "demofin"

  defp conn do
    {:ok, token} = Goth.fetch(McpBigQuery.Goth)
    Connection.new(token.token)
  end

  def list_tables do
    {:ok, resp} =
      Tables.bigquery_tables_list(conn(), @project, @dataset)

    resp.tables
    |> Enum.map(& &1.tableReference.tableId)
  end

  def describe_table(table) do
    {:ok, resp} =
      Tables.bigquery_tables_get(conn(), @project, @dataset, table)

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
      Jobs.bigquery_jobs_query(conn(), @project, body: request)

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
end
