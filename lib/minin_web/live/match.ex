defmodule MininWeb.Live.Match do
  @moduledoc """
  A LiveView showing a specific match.
  """

  use MininWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    _match = Minin.MatchRegistry.lookup(Minin.MatchRegistry, id)
    {:ok, assign(socket, :id, id)}
  end
end
