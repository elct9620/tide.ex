defmodule Tide.StateTest do
  use ExUnit.Case
  doctest Tide.State

  setup do
    {:ok, pid} = Tide.State.start_link()
    {:ok, state: pid}
  end

  test "Can convert to list", %{state: state} do
    assert [] == state |> Tide.State.to_list
  end

  test "Can change state", %{state: state} do
    assert [] == state |> Tide.State.to_list
    state |> Tide.State.put(:name, "Bob")
    assert [] != state |> Tide.State.to_list
  end

  test "Can get state by key", %{state: state} do
    state |> Tide.State.put(:name, "Jimmy")
    assert "Jimmy" == state |> Tide.State.get(:name)
  end

  test "When key not exist return nil", %{state: state} do
    assert nil == state |> Tide.State.get(:name)
  end
end
