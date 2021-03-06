defmodule Minin.Match do
  @moduledoc """
  A single match.
  """

  use Agent, restart: :temporary

  alias Minin.Match
  alias Minin.Piece

  @type board :: %{Ecto.UUID.t() => [Piece.t()]}
  @type available :: %{Ecto.UUID.t() => [Piece.t()]}
  @type resource :: :iron_ore
  @type results :: %{resource() => integer()}
  @type step :: {Piece.t(), results()}
  @type steps :: %{Ecto.UUID.t() => [step()]}
  @type status :: {:configure, board(), available()} | {:run, steps()}

  @type t :: %Minin.Match{
          id: Ecto.UUID.t(),
          status: status()
        }

  @enforce_keys [:id]
  defstruct [
    :id,
    status: {:configure, %{}, %{}}
  ]

  @spec init_players(Minin.Match.t()) :: Minin.Match.t()
  defp init_players(match) do
    player_ids =
      Stream.repeatedly(&Ecto.UUID.generate/0)
      |> Enum.take(4)

    board = Map.new(player_ids, fn id -> {id, []} end)

    available = Map.new(player_ids, fn id -> {id, default_pieces()} end)

    %{match | status: {:configure, board, available}}
  end

  @spec default_pieces() :: [Piece.t()]
  defp default_pieces() do
    Stream.repeatedly(fn -> Enum.random([:drill, :multiplier]) end) |> Enum.take(6)
  end

  @spec select_piece(pid(), Ecto.UUID.t(), Piece.t()) :: :ok
  def select_piece(pid, player_id, piece) when is_pid(pid) do
    Agent.update(pid, fn match ->
      select_piece(match, player_id, piece)
    end)
  end

  @spec select_piece(t(), Ecto.UUID.t(), Piece.t()) :: t()
  def select_piece(%Match{status: {:configure, board, available}} = match, player_id, piece) do
    board = Map.update!(board, player_id, &[piece | &1])
    available = Map.update!(available, player_id, &List.delete(&1, piece))

    %{match | status: {:configure, board, available}}
  end

  @spec start_run(pid()) :: :ok
  def start_run(pid) when is_pid(pid) do
    Agent.update(pid, fn match ->
      start_run(match)
    end)
  end

  @spec start_run(t()) :: t()
  def start_run(%Match{status: {:configure, board, _available}} = match) do
    steps =
      Map.map(board, fn {_id, pieces} ->
        Enum.reduce(pieces, [], &run_step/2)
        |> Enum.reverse()
      end)

    %{match | status: {:run, steps}}
  end

  @spec run_step(Minin.Piece.t(), [step()]) :: [step()]
  def run_step(piece, steps) do
    {_previous_piece, previous_output} = List.first(steps, {nil, %{}})
    next_step = {piece, Minin.Piece.run(piece, previous_output)}
    [next_step | steps]
  end

  def start_link(opts) do
    Agent.start_link(fn -> init_players(%Match{id: opts[:id]}) end, opts)
  end

  @spec get_match(atom | pid | {atom, any} | {:via, atom, any}) :: t()
  def get_match(pid) do
    Agent.get(pid, &Function.identity/1)
  end

  @spec id(atom | pid | {atom, any} | {:via, atom, any}) :: Ecto.UUID.t()
  def id(pid) do
    Agent.get(pid, &Map.get(&1, :id))
  end
end
