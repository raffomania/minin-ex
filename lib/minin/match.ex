defmodule Minin.Match do
  @moduledoc """
  A single match.
  """

  use Agent, restart: :temporary

  alias Minin.Match

  @enforce_keys [:id]
  defstruct [:id, players: [%Minin.MatchPlayer{}, %Minin.MatchPlayer{}]]

  def start_link(opts) do
    Agent.start_link(fn -> %Match{id: opts[:id]} end, opts)
  end

  def id(match) do
    Agent.get(match, &Map.get(&1, :id))
  end

  def players(match) do
    Agent.get(match, &Map.get(&1, :players))
  end
end
