defmodule MininWeb.Live.Match do
  @moduledoc """
  Show a specific match.
  """

  use MininWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    {:ok, _match} = Minin.MatchRegistry.lookup(Minin.MatchRegistry, id)
    {:ok, assign(socket, :id, id)}
  end
end
