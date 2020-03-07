defmodule Tide.ReactionTest do
  use ExUnit.Case
  doctest Tide.Reaction

  setup do
    {:ok, pid} = Tide.Reaction.start_link()
    {:ok, reaction: pid}
  end

  describe "Tide.Reaction.next/1" do
    test "returns nil", %{reaction: reaction} do
      assert nil == reaction |> Tide.Reaction.next
    end
  end

  describe "Tide.Reaction.push/2" do
    test "returns :ok", %{reaction: reaction} do
      assert :ok == reaction |> Tide.Reaction.push(:event)
      assert :event == reaction |> Tide.Reaction.next
    end
  end
end
