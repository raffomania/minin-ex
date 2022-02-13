defmodule Minin.Match do
  use Agent

  def start_link(id, opts) do
    IO.puts("started match!")
    Agent.start_link(fn -> %{id: id} end, opts)
  end
end
