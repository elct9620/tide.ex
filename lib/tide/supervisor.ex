defmodule Tide.Supervisor do
  @moduledoc """
  The default Supervisor for Tide, the default workers size is same as CPU cores

  See `Tide.Server` for more information
  """
  use Tide.Server

  @impl true
  def size(), do: :erlang.system_info(:logical_processors) |> default_size

  defp default_size(:unknown), do: 1
  defp default_size(v), do: v
end
