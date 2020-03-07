defmodule Tide.Reaction do
  @moduledoc """
  The queue of ruby response
  """

  use GenServer

  @doc "Create a new reaction queue"
  def start_link(queue \\ []), do: GenServer.start_link(__MODULE__, queue)

  @impl true
  def init(queue), do: {:ok, queue}
end
