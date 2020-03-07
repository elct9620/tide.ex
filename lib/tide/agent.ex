defmodule Tide.Agent do
  @moduledoc """
  The handler of Tide
  """

  use GenServer

  @doc "Start a new agent"
  def start_link(), do: GenServer.start_link(__MODULE__, [])

  # TODO: Allow customize Reaction and State
  @impl true
  def init([]) do
    {:ok, reaction} = Tide.Reaction.start_link()
    {:ok, state} = Tide.Reaction.start_link()
    {:ok, [reaction, state]}
  end

  @impl true
  def handle_call(:reaction, _from, [reaction, state]), do: {:reply, reaction, [reaction, state]}

  @impl true
  def handle_call(:state, _from, [reaction, state]), do: {:reply, state, [reaction, state]}

  @doc "Get reaction"
  def reaction(pid), do: pid |> GenServer.call(:reaction)

  @doc "Get state"
  def state(pid), do: pid |> GenServer.call(:state)
end
