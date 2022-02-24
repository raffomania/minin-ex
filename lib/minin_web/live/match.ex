defmodule MininWeb.Live.Match do
  @moduledoc """
  Show a specific match.
  """

  use MininWeb, :live_view

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    {:ok, pid} = Minin.MatchRegistry.lookup(Minin.MatchRegistry, id)

    socket = assign(socket, match: Minin.Match.get_match(pid), match_pid: pid)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("select_piece", %{"player-id" => player_id, "piece" => piece}, socket) do
    {:ok, player_id} = Ecto.UUID.cast(player_id)
    piece = String.to_existing_atom(piece)

    pid = socket.assigns.match_pid
    Minin.Match.select_piece(pid, player_id, piece)

    socket = assign(socket, :match, Minin.Match.get_match(pid))
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("start_run", %{}, socket) do
    pid = socket.assigns.match_pid

    Minin.Match.start_run(pid)

    socket = assign(socket, :match, Minin.Match.get_match(pid))
    {:noreply, socket}
  end
end
