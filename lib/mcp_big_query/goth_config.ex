defmodule McpBigQuery.GothConfig do
  @scopes ["https://www.googleapis.com/auth/cloud-platform"]

  def child_spec do
    case get_credentials() do
      :error ->
        []

      credentials ->
        [
          {Goth,
           name: McpBigQuery.Goth, source: {:service_account, credentials, [scopes: @scopes]}}
        ]
    end
  end

  defp get_credentials do
    case Application.get_env(:goth, :keyfile) do
      keyfile when is_binary(keyfile) and byte_size(keyfile) > 0 ->
        keyfile
        |> File.read!()
        |> Jason.decode!()

      _ ->
        :error
    end
  end
end
