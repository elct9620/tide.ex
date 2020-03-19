defmodule Tide.Server do
  defmacro __using__(_params) do
    quote do
      def child_spec(opts) do
        :poolboy.child_spec(__MODULE__, config(), opts)
      end

      def worker(), do: Tide.Worker
      def size(), do: 1
      def overflow(), do: 1

      defp config() do
        [
          name: {:local, :tide},
          worker_module: worker(),
          size: size(),
          max_overflow: overflow()
        ]
      end

      defoverridable [size: 0, overflow: 0, worker: 0]
    end
  end

  # TODO: Support multiple server
  def exec(handler, event, args), do: :poolboy.transaction(:tide, fn(pid) -> Tide.Worker.exec(pid, handler, event, args) end)
  def emit(handler, event, args), do: :poolboy.transaction(:tide, fn(pid) -> Tide.Worker.emit(pid, handler, event, args) end)
end
