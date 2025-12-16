# MCP Bigquery

**Simple MCP for Google BigQuery**

This is a simple http server running an MCP for Google BigQuery.
The agent currently only have implemented:

tools/list_tables
tools/describe_table
tools/execute_query

## Installation

Clone the Repo

`git clone https://github.com/amco/mcp_big_query.git`

## Configuration

Rename `config/_runtime.exs.bkp` into `config/runtime.exs` and set your conguration


```elixir
import Config

config :goth,
  keyfile: "path/to/servvice_account.json

config :mcp_big_query,
  api_key: "Secret"
```


## Run the proyect

`PORT=4040 mix -S`

The server will start and now you should be able to use it.

Check https://hexdocs.pm/hermes_mcp/home.html
For more information and ways to extend it.
