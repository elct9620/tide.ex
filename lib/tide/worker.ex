defmodule Tide.Worker do
  @moduledoc """
  The GenServer to manage ruby processes
  """
  use GenServer

  def start_link(options), do: GenServer.start_link(__MODULE__, options)

  @impl true
  def init(options), do: :ruby.start_link(ruby_lib: [root(options) | tide_dir()]) |> register |> load(options)

  @impl true
  def handle_call({:exec, handler, event, args}, from, ruby) do
    ruby |> :ruby.cast({:exec, handler ++ [from], event, args})
    {:noreply, ruby}
  end

  @impl true
  def handle_cast({:emit, handler, event, args}, ruby) do
    ruby |> :ruby.cast({:emit, handler, event, args})
    {:noreply, ruby}
  end

  @impl true
  def handle_info({:ok, from, args}, ruby) do
    GenServer.reply(from, args)
    {:noreply, ruby}
  end

  @doc "Trigger an event"
  def emit(pid, handler, event, args \\ []), do: GenServer.cast(pid, {:emit, handler, event, args})

  @doc "Trigger an event with reply"
  def exec(pid, handler, event, args \\ []), do: GenServer.call(pid, {:exec, handler, event, args})

  defp tide_dir(), do: [:code.priv_dir(:tide)]
  defp root(options), do: Keyword.get(options, :root, "") |> Path.expand |> String.to_charlist
  defp file(options), do: Keyword.get(options, :file, "elixir/tide") |> String.to_atom
  defp function(options), do: Keyword.get(options, :function, "Elixir::Tide::ok") |> String.to_atom

  defp register({:ok, ruby}), do: ruby |> :ruby.call(:"elixir/tide", :"Elixir::Tide::init", [self(), ruby])
  defp load({:ok, ruby}, options), do: ruby |> :ruby.call(file(options), function(options), [ruby])
end
