defmodule Minin.Piece do
  @moduledoc """
  A piece that can be placed in a match.
  """

  @type t :: :drill | :multiplier

  @spec name(t()) :: String.t()
  def name(piece) do
    Atom.to_string(piece)
  end

  @spec run(t(), Minin.Match.results()) :: Minin.Match.results()
  def run(piece, input) do
    case(piece) do
      :drill ->
        Map.update(input, :iron_ore, 1, fn ore -> ore + 1 end)

      :multiplier ->
        Map.map(input, fn {_key, val} -> val * 2 end)
    end
  end
end
