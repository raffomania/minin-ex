defmodule MininWeb.Live.Index do
  @moduledoc """
  Index page.
  """

  use MininWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("start_game", _params, socket) do
    {id, _match} = Minin.MatchRegistry.find(Minin.MatchRegistry)
    socket = push_redirect(socket, to: Routes.live_path(socket, MininWeb.Live.Match, id))
    {:noreply, socket}
  end
end
