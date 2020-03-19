defmodule Tide.Supervisor do
  use Tide.Server

  def size(), do: :erlang.system_info(:logical_processors) |> default_size

  defp default_size(:unknown), do: 1
  defp default_size(v), do: v
end
