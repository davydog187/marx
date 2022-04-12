defmodule MarxTest do
  use ExUnit.Case
  doctest Marx

  test "greets the world" do
    assert Marx.hello() == :world
  end
end
