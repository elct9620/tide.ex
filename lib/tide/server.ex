defmodule Tide.Server do
  @moduledoc """
  The `Tide.Server` is similar to `GenServer` but create a Ruby worker pool.

  You can create your own supervisor with
      defmodule MyApp.Supervisor do
        use Tide.Server

        def size(), do: Application.get_env(:tide, :workers, 4)
      end
  """

  @doc "Set the worker size"
  @callback size() :: integer()

  @doc "Set the max overflow worker"
  @callback overflow() :: integer()

  defmacro __using__(params) do
    size = Keyword.get(params, :size)

    quote do
      @behaviour Tide.Server

      @doc false
      def child_spec(opts) do
        :poolboy.child_spec(__MODULE__, config(), opts)
      end

      @doc false
      def size(), do: 1
      @doc false
      def overflow(), do: 1

      defp config() do
        [
          name: {:local, :tide},
          worker_module: Tide.Worker,
          size: unquote(size) || size(),
          max_overflow: overflow()
        ]
      end

      defoverridable size: 0, overflow: 0
    end
  end

  # TODO: Support multiple server

  @doc """
  Pick a worker and exec event

  See `Tide.Worker.exec/4`
  """
  def exec(handler, event, args), do: :poolboy.transaction(:tide, fn(pid) -> Tide.Worker.exec(pid, handler, event, args) end)

  @doc """
  Pick a worker and emit event

  See `Tide.Worker.emit/4`
  """
  def emit(handler, event, args), do: :poolboy.transaction(:tide, fn(pid) -> Tide.Worker.emit(pid, handler, event, args) end)
end
