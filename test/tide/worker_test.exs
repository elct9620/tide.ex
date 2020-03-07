defmodule Tide.WorkerTest do
  use ExUnit.Case
  doctest Tide.Worker

  setup do
    {:ok, pid} = Tide.Worker.start_link("test/assets/ruby")
    {:ok, agent: pid}
  end

  test "Can load ruby file" do
    assert :ok == Tide.Worker.load("load")
  end

  test "Can load with callback" do
    assert :callback == Tide.Worker.load("load", "callback")
  end

  test "Can receive result by exec event" do
    Tide.Worker.load("exec")
    assert :ok == Tide.Worker.exec([nil, nil], "test", [])
  end

  # TODO: Test emit
end
