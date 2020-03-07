defmodule Tide.WorkerTest do
  use ExUnit.Case
  doctest Tide.Worker

  setup do
    {:ok, pid} = Tide.Worker.start_link("test/assets/ruby")
    {:ok, agent: pid}
  end

  describe "Tide.Worker.load/1" do
    test "returns :ok" do
      assert :ok == Tide.Worker.load("load")
    end
  end

  describe "Tide.Worker.load/2" do
    test "returns callback result" do
      assert :callback == Tide.Worker.load("load", "callback")
    end
  end

  describe "Tide.Worker.exec/3" do
    test "returns event result" do
      Tide.Worker.load("exec")
      assert :ok == Tide.Worker.exec([nil, nil], "test", [])
    end
  end

  # TODO: Test emit
end
