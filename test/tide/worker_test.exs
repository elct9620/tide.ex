defmodule Tide.WorkerTest do
  use ExUnit.Case
  doctest Tide.Worker

  setup do
    {:ok, pid} = Tide.Worker.start_link(root: "test/assets/ruby", file: "exec")
    {:ok, worker: pid}
  end

  describe "Tide.Worker.exec/4" do
    test "returns event result", %{ worker: worker } do
      assert :ok == worker |> Tide.Worker.exec([nil, []], "use_block", [])
    end
  end

  # TODO: Test emit
end
