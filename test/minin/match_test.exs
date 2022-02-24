defmodule Minin.MatchTest do
  @moduledoc false

  use ExUnit.Case, async: true

  setup do
    pid = start_supervised!(Minin.Match)
    %{pid: pid}
  end

  test "start with some players with pieces", %{pid: pid} do
    %{status: {:configure, board, available}} = Minin.Match.get_match(pid)
    refute Enum.empty?(available)
    refute Enum.empty?(board)

    Enum.each(available, fn {_id, pieces} ->
      refute Enum.empty?(pieces)
    end)

    Enum.each(board, fn {_id, pieces} ->
      assert Enum.empty?(pieces)
    end)
  end

  test "can select a piece", %{pid: pid} do
    %{status: {:configure, board, available}} = Minin.Match.get_match(pid)
    {player_id, _player_board} = Enum.at(board, 0)
    assert Enum.empty?(board[player_id])
    [piece | _rest] = available[player_id]
    Minin.Match.select_piece(pid, player_id, piece)
    %{status: {:configure, new_board, _new_available}} = Minin.Match.get_match(pid)
    assert new_board[player_id] == [piece]
  end
end
