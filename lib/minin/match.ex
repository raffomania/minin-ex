defmodule Minin.Match do
  @moduledoc """
  A single match.
  """

  use Agent, restart: :temporary

  def start_link(opts) do
    Agent.start_link(fn -> %{id: opts[:id]} end, opts)
  end

  def id(match) do
    Agent.get(match, &Map.get(&1, :id))
  end
end
