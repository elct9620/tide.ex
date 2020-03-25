defmodule Tide.State do
  @moduledoc """
  The state of agent
  """

  use GenServer

  @doc "Create a new state"
  def start_link(state \\ %{}), do: GenServer.start_link(__MODULE__, state)

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call({:to_list}, _from, state), do: {:reply, state |> Map.to_list, state}

  @impl true
  def handle_call({:put, key, value}, _from, state) do
    new = state |> Map.put(key, value)
    {:reply, new, new}
  end

  @impl true
  def handle_call({:get, key}, _from, state), do: {:reply, state |> Map.get(key), state}

  # TODO: Check for keyword list
  @doc "Convert to list"
  def to_list(state) when is_list(state), do: state
  def to_list(state) when is_map(state), do: state |> Map.to_list
  def to_list(pid), do: pid |> GenServer.call({:to_list})

  @doc "Get value"
  def get(pid, key), do: pid |> GenServer.call({:get, key})

  @doc "Put value"
  def put(pid, key, value), do: pid |> GenServer.call({:put, key, value})
end
