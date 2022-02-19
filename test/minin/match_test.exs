defmodule Minin.MatchTest do
  @moduledoc false

  use ExUnit.Case, async: true

  setup do
    pid = start_supervised!(Minin.Match)
    %{pid: pid}
  end

  test "start with some players with pieces", %{pid: pid} do
    players = Minin.Match.players(pid)
    refute Enum.empty?(players)

    Enum.each(players, fn player ->
      refute Enum.empty?(player.available_pieces)
      assert Enum.empty?(player.selected_pieces)
    end)
  end

  test "can select a piece", %{pid: pid} do
    [player | _rest] = Minin.Match.players(pid)
    assert Enum.empty?(player.selected_pieces)
    [piece | _rest] = player.available_pieces
    Minin.Match.select_piece(pid, player.id, piece)
    [updated_player | _rest] = Minin.Match.players(pid)
    assert updated_player.selected_pieces == [piece]
  end
end
