defmodule Tide.AgentTest do
  use ExUnit.Case
  doctest Tide

  setup do
    {:ok, pid} = Tide.Agent.start_link("test/assets/ruby")
    {:ok, agent: pid}
  end

  test "Can load ruby file" do
    assert :ok == Tide.Agent.load("load")
  end

  test "Can load with callback" do
    assert :callback == Tide.Agent.load("load", "callback")
  end
end
