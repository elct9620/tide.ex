defmodule Tide.StateTest do
  use ExUnit.Case
  doctest Tide.State

  setup do
    {:ok, pid} = Tide.State.start_link()
    {:ok, state: pid}
  end

  describe "Tide.State.to_list/1" do
    test "returns []", %{state: state} do
      assert [] == state |> Tide.State.to_list
    end

    test "returns [] when input an empty list" do
      assert [] == [] |> Tide.State.to_list
    end

    test "returns [] when input an empty map" do
      assert [] == %{} |> Tide.State.to_list
    end
  end

  describe "Tide.State.put/3" do
    test "change :name to Bob", %{state: state} do
      assert [] == state |> Tide.State.to_list
      state |> Tide.State.put(:name, "Bob")
      assert [] != state |> Tide.State.to_list
    end
  end

  describe "Tide.State.get/3" do
    test "get :name returns Jimmy", %{state: state} do
      state |> Tide.State.put(:name, "Jimmy")
      assert "Jimmy" == state |> Tide.State.get(:name)
    end

    test "no :name key returns nil", %{state: state} do
      assert nil == state |> Tide.State.get(:name)
    end
  end
end
