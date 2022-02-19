defmodule Minin.Match do
  @moduledoc """
  A single match.
  """

  use Agent, restart: :temporary

  alias Minin.Match

  @type t :: %Minin.Match{
          id: Ecto.UUID.t(),
          players: [Minin.MatchPlayer.t()]
        }

  @enforce_keys [:id]
  defstruct [
    :id,
    players: []
  ]

  @spec init_players(Minin.Match.t()) :: Minin.Match.t()
  defp init_players(match) do
    players =
      Stream.repeatedly(&Minin.MatchPlayer.new/0)
      |> Enum.take(4)

    %{match | players: players}
  end

  def select_piece(pid, player_id, piece) do
    update_player = fn player ->
      case player.id do
        ^player_id -> Minin.MatchPlayer.select_piece(player, piece)
        _other -> player
      end
    end

    Agent.update(pid, fn match ->
      players =
        match.players
        |> Enum.map(update_player)

      %{match | players: players}
    end)
  end

  def start_link(opts) do
    Agent.start_link(fn -> init_players(%Match{id: opts[:id]}) end, opts)
  end

  def get_match(pid) do
    Agent.get(pid, &Function.identity/1)
  end

  def id(pid) do
    Agent.get(pid, &Map.get(&1, :id))
  end

  @spec players(atom | pid | {atom, any} | {:via, atom, any}) :: [Minin.MatchPlayer.t()]
  def players(pid) do
    Agent.get(pid, &Map.get(&1, :players))
  end
end
