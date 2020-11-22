defmodule SugarcaneTest do
  use ExUnit.Case
  doctest Sugarcane

  test "greets the world" do
    assert Sugarcane.hello() == :world
  end
end
