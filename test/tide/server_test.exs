defmodule Tide.ServerTest do
  use Tide.ServerCase
  doctest Tide.Server

  describe "Tide.Server.exec/3" do
    @tag tide_file: "exec"
    test "return :ok" do
      assert :ok = Tide.Server.exec([nil, []], "use_block", [])
    end
  end
end
