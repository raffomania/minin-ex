defmodule MininWeb.Live.Match do
  use MininWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    match = Minin.MatchRegistry.lookup(Minin.MatchRegistry, id)
    IO.inspect(match)
    {:ok, assign(socket, :id, id)}
  end
end
