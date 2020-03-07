defmodule Tide.ReactionTest do
  use ExUnit.Case
  doctest Tide.Reaction

  setup do
    {:ok, pid} = Tide.Reaction.start_link()
    {:ok, reaction: pid}
  end

  test "Can get from empty queue", %{reaction: reaction} do
    assert nil == reaction |> Tide.Reaction.next
  end

  test "Can add reaction to queue", %{reaction: reaction} do
    assert :ok == reaction |> Tide.Reaction.push(:event)
    assert :event == reaction |> Tide.Reaction.next
  end
end
