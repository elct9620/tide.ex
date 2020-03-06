defmodule Tide.Agent do
  @moduledoc """
  The GenServer to manage ruby processes
  """
  use GenServer

  # TODO: Allow configure options
  def start_link(app_dir), do: GenServer.start_link(__MODULE__, app_dir, name: __MODULE__)

  @impl true
  def init(app_dir), do: :ruby.start_link(ruby_lib: [Path.expand(app_dir) |> String.to_charlist | tide_dir()]) |> register_handler

  @impl true
  def handle_cast({:exec, from, command, args}, ruby) do
    ruby |> :ruby.cast({from, command, args})
    {:noreply, ruby}
  end

  @impl true
  def handle_call({:load, file, function}, _from, ruby), do: {:reply, ruby |> :ruby.call(String.to_atom(file), String.to_atom(function), []), ruby}

  @doc "Execute command with arguments"
  def exec(from, command, args \\ []), do: GenServer.cast(__MODULE__, {:exec, from, command, args})

  @doc "Load Ruby file"
  def load(file, function \\ "load"), do: GenServer.call(__MODULE__, {:load, file, function})

  defp tide_dir(), do: [:code.priv_dir(:tide)]
  defp register_handler({:ok, ruby}), do: ruby |> :ruby.call(:"elixir/tide", :"Elixir::Tide::init", [self(), ruby])
end
