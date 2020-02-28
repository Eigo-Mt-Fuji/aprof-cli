defmodule AprofCliTest do
  use ExUnit.Case
  doctest AprofCli

  test "greets the world" do
    assert AprofCli.hello() == :world
  end
end
