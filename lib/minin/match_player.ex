defmodule Minin.MatchPlayer do
  @moduledoc """
  The state for a player in a match.
  """
  @type t :: %Minin.MatchPlayer{
          id: Ecto.UUID.t(),
          available_pieces: [Minin.Piece.t()],
          selected_pieces: [Minin.Piece.t()]
        }

  @enforce_keys :id
  defstruct [:id, available_pieces: [], selected_pieces: []]

  @spec new :: t()
  def new() do
    %Minin.MatchPlayer{available_pieces: default_pieces(), id: Ecto.UUID.generate()}
  end

  @spec select_piece(t(), Minin.Piece.t()) :: t()
  def select_piece(player, piece) do
    %{
      player
      | available_pieces: List.delete(player.available_pieces, piece),
        selected_pieces: [piece] ++ player.selected_pieces
    }
  end

  @spec default_pieces() :: [Minin.Piece.t()]
  defp default_pieces() do
    Stream.repeatedly(fn -> :drill end) |> Enum.take(6)
  end
end
