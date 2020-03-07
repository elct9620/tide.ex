defmodule Tide.Worker do
  @moduledoc """
  The GenServer to manage ruby processes
  """
  use GenServer

  # TODO: Allow configure options
  def start_link(app_dir), do: GenServer.start_link(__MODULE__, app_dir, name: __MODULE__)

  @impl true
  def init(app_dir), do: :ruby.start_link(ruby_lib: [Path.expand(app_dir) |> String.to_charlist | tide_dir()]) |> register_handler

  @impl true
  def handle_call({:load, file, function}, _from, ruby), do: {:reply, ruby |> :ruby.call(String.to_atom(file), String.to_atom(function), []), ruby}

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
  def emit(handler, event, args \\ []), do: GenServer.cast(__MODULE__, {:emit, handler, event, args})

  @doc "Trigger an event with reply"
  def exec(handler, event, args \\ []), do: GenServer.call(__MODULE__, {:exec, handler, event, args})

  @doc "Load Ruby file"
  def load(file, function \\ "Elixir::Tide::ok"), do: GenServer.call(__MODULE__, {:load, file, function})

  defp tide_dir(), do: [:code.priv_dir(:tide)]
  defp register_handler({:ok, ruby}), do: ruby |> :ruby.call(:"elixir/tide", :"Elixir::Tide::init", [self(), ruby])
end
