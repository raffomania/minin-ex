defmodule Minin.MatchRegistry do
  use GenServer

  def lookup(server, id) do
    GenServer.call(server, {:lookup, id})
  end

  def create(server) do
    GenServer.call(server, {:create})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:lookup, id}, _from, matches) do
    {:reply, Map.fetch!(matches, id), matches}
  end

  @impl true
  def handle_call({:create}, _from, matches) do
    id = Ecto.UUID.generate()
    {:ok, match} = Minin.Match.start_link(id, [])
    {:reply, match, Map.put(matches, id, match)}
  end
end
