defmodule Tide.Agent do
  @moduledoc """
  The handler of Tide
  """

  use GenServer

  @doc "Start a new agent"
  def start_link(state \\ []), do: GenServer.start_link(__MODULE__, state)

  # TODO: Allow customize Reaction and State
  @impl true
  def init(state) do
    {:ok, reaction} = Tide.Reaction.start_link()
    {:ok, [reaction, state]}
  end

  @impl true
  def handle_call(:reaction, _from, [reaction, _] = handler), do: {:reply, reaction, handler}

  @impl true
  def handle_call(:next, _from, [reaction, _] = handler), do: {:reply, reaction |> Tide.Reaction.next, handler}

  @impl true
  def handle_call(:state, _from, [_, state] = handler), do: {:reply, state, handler}

  @impl true
  def handle_call({:update, callback}, _from, [reaction, state]) when is_function(callback), do: {:reply, :ok, [reaction, callback.(state)]}
  def handle_call({:update, state}, _from, [reaction, _]), do: {:reply, :ok, [reaction, state]}

  @impl true
  def handle_call({:exec, command, args}, _from, [reaction, state] = handler), do: {:reply, Tide.Server.exec([reaction, state |> Tide.State.to_list], command, args), handler}

  @impl true
  def handle_cast({:emit, command, args}, [reaction, state] = handler) do
    Tide.Server.emit([reaction, state |> Tide.State.to_list], command, args)
    {:noreply, handler}
  end

  @doc "Get reaction"
  def reaction(pid), do: pid |> GenServer.call(:reaction)

  @doc """
  Get next reaction

  See `Tide.Reaction.next/1`
  """
  def next(pid), do: pid |> GenServer.call(:next)

  @doc "Get the state"
  def state(pid), do: pid |> GenServer.call(:state)

  @doc "Update the state"
  def update(pid, callback), do: pid |> GenServer.call({:update, callback})

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
