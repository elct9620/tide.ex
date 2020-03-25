defmodule Tide.AgentTest do
  use Tide.ServerCase
  doctest Tide.Agent

  setup do
    {:ok, agent} = Tide.Agent.start_link()
    {:ok, agent: agent}
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

  describe "Tide.Agent.state/1" do
    setup %{state: state} do
      {:ok, agent} = Tide.Agent.start_link(state)
      {:ok, agent: agent}
    end

    @tag state: [1]
    test "returns [1] as default state", %{agent: agent} do
      assert [1] == agent |> Tide.Agent.state
    end
  end

  describe "Tide.Agent.update/2" do
    test "returns [1] after update state", %{agent: agent} do
      agent |> Tide.Agent.update([1])
      assert [1] == agent |> Tide.Agent.state
    end

    test "returns [1] after update state by function", %{agent: agent} do
      agent |> Tide.Agent.update(fn state -> state ++ [1] end)
      assert [1] == agent |> Tide.Agent.state
    end
  end

  describe "Tide.Agent.exec/2" do
    @tag tide_file: "exec"
    test "ruby use block to returns :ok", %{agent: agent} do
      assert :ok = agent |> Tide.Agent.exec("use_block")
    end

    @tag tide_file: "exec"
    test "ruby use block with args to returns :ok", %{agent: agent} do
      assert :ok = agent |> Tide.Agent.exec("use_block_arg", ["Hi"])
    end

    @tag tide_file: "exec"
    test "ruby use reply to returns :ok", %{agent: agent} do
      assert :ok = agent |> Tide.Agent.exec("use_reply")
    end

    @tag tide_file: "exec"
    test "ruby use reply with args to returns :ok", %{agent: agent} do
      assert {:ok, ["Hi"]} = agent |> Tide.Agent.exec("use_reply_arg", ["Hi"])
    end
  end

  describe "Tide.Agent.emit/2" do
    @tag tide_file: "emit"
    test "returns :ok", %{agent: agent} do
      agent |> Tide.Agent.emit("test")
      # TODO: Prevent wait by timer
      :timer.sleep(10)
      assert {:ok, _} = agent |> Tide.Agent.reaction |> Tide.Reaction.next
    end
  end
end
