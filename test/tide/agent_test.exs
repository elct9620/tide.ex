defmodule Tide.AgentTest do
  use ExUnit.Case
  doctest Tide.Agent

  setup do
    {:ok, worker} = Tide.Worker.start_link("test/assets/ruby")
    {:ok, agent} = Tide.Agent.start_link()
    {:ok, worker: worker, agent: agent}
  end

  describe "Tide.Agent.state/1" do
    test "returns pid", %{agent: agent} do
      assert is_pid(agent |> Tide.Agent.state)
    end
  end

  describe "Tide.Agent.put/3" do
    test "returns :ok", %{agent: agent} do
      agent |> Tide.Agent.put(:name, "Alice")
      assert [] != agent |> Tide.Agent.state |> Tide.State.to_list
    end
  end

  describe "Tide.Agent.get/2" do
    test "returns John", %{agent: agent} do
      agent |> Tide.Agent.state |> Tide.State.put(:name, "John")
      assert "John" == agent |> Tide.Agent.get(:name)
    end
  end

  describe "Tide.Agent.reaction/1" do
    test "returns pid", %{agent: agent} do
      assert is_pid(agent |> Tide.Agent.reaction)
    end
  end

  describe "Tide.Agent.next/1" do
    test "returns next reaction", %{agent: agent} do
      agent |> Tide.Agent.reaction |> Tide.Reaction.push(:ok)
      assert :ok == agent |> Tide.Agent.next
    end

    test "returns nil when reaction is empty", %{agent: agent} do
      assert nil == agent |> Tide.Agent.next
    end
  end

  describe "Tide.Agent.exec/2" do
    test "returns :ok", %{agent: agent} do
      Tide.Worker.load("exec")
      assert :ok = agent |> Tide.Agent.exec("test")
    end
  end

  describe "Tide.Agent.emit/2" do
    test "returns :ok", %{agent: agent} do
      Tide.Worker.load("emit")
      agent |> Tide.Agent.emit("test")
      # TODO: Prevent wait by timer
      :timer.sleep(10)
      assert {:ok, _} = agent |> Tide.Agent.reaction |> Tide.Reaction.next
    end
  end
end
