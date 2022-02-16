defmodule MininWeb.Live.Match do
  @moduledoc """
  Show a specific match.
  """

  use MininWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    {:ok, match} = Minin.MatchRegistry.lookup(Minin.MatchRegistry, id)
    players = IO.inspect(Minin.Match.players(match))
    socket = assign(socket, :players, players)
    {:ok, assign(socket, :id, id)}
  end
end
