defmodule Tide.ServerCase do
  use ExUnit.CaseTemplate

  defmodule DummySupervisor do
    use Tide.Server
  end

  setup [:start_server]

  defp start_server(%{tide_file: file}) do
    start_supervised({DummySupervisor, root: "test/assets/ruby", file: file})
    :ok
  end
  defp start_server(_), do: :ok
end
