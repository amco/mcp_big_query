defmodule McpBigQuery.GothConfig do
  @scopes ["https://www.googleapis.com/auth/cloud-platform"]

  def child_spec do
    [
      {Goth, name: McpBigQuery.Goth, source: {:service_account, credentials(), [scopes: @scopes]}}
    ]
  end

  defp credentials do
    Application.get_env(:goth, :keyfile)
    |> File.read!()
    |> Jason.decode!()
  end
end
