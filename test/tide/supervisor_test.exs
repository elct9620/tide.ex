defmodule Tide.SupervisorTest do
  use ExUnit.Case
  doctest Tide.Supervisor

  describe "Tide.Supervisor.size/0" do
    test "is integer" do
      assert is_integer(Tide.Supervisor.size())
    end
  end
end
