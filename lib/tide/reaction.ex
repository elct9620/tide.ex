defmodule Tide.Reaction do
  @moduledoc """
  The queue of ruby response
  """

  use GenServer

  @doc "Create a new reaction queue"
  def start_link(queue \\ []), do: GenServer.start_link(__MODULE__, queue)

  @impl true
  def init(queue), do: {:ok, queue}

  @impl true
  def handle_call(:next, _from, [head | queue]), do: {:reply, head, queue}

  @impl true
  def handle_call(:next, _from, []), do: {:reply, nil, []}

  @impl true
  def handle_cast({:push, reaction}, queue), do: {:noreply, queue ++ [reaction]}

  @impl true
  def handle_info(reaction, queue), do: {:noreply, queue ++ [reaction]}

  @doc "Get next reaction"
  def next(pid), do: pid |> GenServer.call(:next)

  @doc "Add new reaction"
  def push(pid, reaction), do: pid |> GenServer.cast({:push, reaction})
end
