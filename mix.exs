defmodule McpBigQuery.MixProject do
  use Mix.Project

  def project do
    [
      app: :mcp_big_query,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {McpBigQuery.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hermes_mcp, "~> 0.4"},
      {:plug, "~> 1.15"},
      {:bandit, "~> 1.5"},
      {:google_api_big_query, "~> 0.48"},
      {:goth, "~> 1.4"},
      {:jason, "~> 1.4"}
    ]
  end
end
