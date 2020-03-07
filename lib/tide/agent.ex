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
    {:ok, state} = Tide.State.start_link()
    {:ok, [reaction, state]}
  end

  @impl true
  def handle_call(:reaction, _from, [reaction, state]), do: {:reply, reaction, [reaction, state]}

  @impl true
  def handle_call(:state, _from, [reaction, state]), do: {:reply, state, [reaction, state]}

  @impl true
  def handle_call({:exec, command, args}, _from, [reaction, state]), do: {:reply, Tide.Worker.exec([reaction, state |> Tide.State.to_list], command, args), [reaction, state]}

  @impl true
  def handle_cast({:emit, command, args}, [reaction, state]) do
    Tide.Worker.emit([reaction, state |> Tide.State.to_list], command, args)
    {:noreply, [reaction, state]}
  end

  @doc "Get reaction"
  def reaction(pid), do: pid |> GenServer.call(:reaction)

  @doc "Get state"
  def state(pid), do: pid |> GenServer.call(:state)

  @doc "Exec a event"
  def exec(pid, command, args \\ []), do: pid |> GenServer.call({:exec, command, args})

  @doc "Emit a event"
  def emit(pid, command, args \\ []), do: pid |> GenServer.cast({:emit, command, args})
end
