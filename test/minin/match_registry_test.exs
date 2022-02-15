defmodule Minin.MatchRegistryTest do
  @moduledoc false

  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(Minin.MatchRegistry)
    %{registry: registry}
  end

  test "matches are temporary" do
    assert Supervisor.child_spec(Minin.Match, []).restart == :temporary
  end

  test "removes match on crash", %{registry: registry} do
    {id, match} = Minin.MatchRegistry.create(registry)

    # Stop the bucket with non-normal reason
    Agent.stop(match, :shutdown)
    # registry should still be alive
    assert Minin.MatchRegistry.lookup(registry, id) == :error
  end
end
