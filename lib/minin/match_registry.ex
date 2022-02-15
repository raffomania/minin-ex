defmodule Minin.MatchRegistry do
  @moduledoc """
  A registry for matches, allowing lookup by ID.
  """

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

  @impl GenServer
  def init(:ok) do
    {:ok, {%{}, %{}}}
  end

  @impl GenServer
  def handle_call({:lookup, id}, _from, {matches, refs}) do
    {:reply, Map.fetch(matches, id), {matches, refs}}
  end

  @impl GenServer
  def handle_call({:create}, _from, {matches, refs}) do
    id = Ecto.UUID.generate()
    {:ok, pid} = DynamicSupervisor.start_child(Minin.MatchSupervisor, {Minin.Match, [id: id]})
    ref = Process.monitor(pid)
    refs = Map.put(refs, ref, id)
    {:reply, {id, pid}, {Map.put(matches, id, pid), refs}}
  end

  @impl GenServer
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {matches, refs}) do
    id = Map.get(refs, ref)
    matches = Map.delete(matches, id)
    {:noreply, {matches, refs}}
  end
end
