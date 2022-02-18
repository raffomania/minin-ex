defmodule Minin.Piece do
  @moduledoc """
  A piece that can be placed in a match.
  """

  @type t :: :drill

  @spec name(Minin.Piece.t()) :: String.t()
  def name(piece) do
    Atom.to_string(piece)
  end
end
