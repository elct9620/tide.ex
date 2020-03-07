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
end
