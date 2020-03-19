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
  def handle_call(:next, _from, [reaction, state]), do: {:reply, reaction |> Tide.Reaction.next, [reaction, state]}

  @impl true
  def handle_call(:state, _from, [reaction, state]), do: {:reply, state, [reaction, state]}

  @impl true
  def handle_call({:put, key, value}, _from, [reaction, state]), do: {:reply, state |> Tide.State.put(key, value), [reaction, state]}

  @impl true
  def handle_call({:get, key}, _from, [reaction, state]), do: {:reply, state |> Tide.State.get(key), [reaction, state]}

  @impl true
  def handle_call({:exec, command, args}, _from, [reaction, state]), do: {:reply, Tide.Server.exec([reaction, state |> Tide.State.to_list], command, args), [reaction, state]}

  @impl true
  def handle_cast({:emit, command, args}, [reaction, state]) do
    Tide.Server.emit([reaction, state |> Tide.State.to_list], command, args)
    {:noreply, [reaction, state]}
  end

  @doc "Get reaction"
  def reaction(pid), do: pid |> GenServer.call(:reaction)

  @doc """
  Get next reaction

  See `Tide.Reaction.next/1`
  """
  def next(pid), do: pid |> GenServer.call(:next)

  @doc "Get state"
  def state(pid), do: pid |> GenServer.call(:state)

  @doc """
  Change state value

  See `Tide.State.put/3`
  """
  def put(pid, key, value), do: pid |> GenServer.call({:put, key, value})

  @doc """
  Get state value

  See `Tide.State.get/2`
  """
  def get(pid, key), do: pid |> GenServer.call({:get, key})

  @doc """
  Exec an event

  See `Tide.Server.exec/3`
  """
  def exec(pid, command, args \\ []), do: pid |> GenServer.call({:exec, command, args})

  @doc """
  Emit an event

  See `Tide.Server.emit/3`
  """
  def emit(pid, command, args \\ []), do: pid |> GenServer.cast({:emit, command, args})
end
