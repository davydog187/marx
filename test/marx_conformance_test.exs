defmodule MarxConformanceTest do
  @moduledoc """
  A test-suite that uses the output of the
  [CommonMark spec](https://github.com/commonmark/commonmark-spec) test suite
  to generate test cases.

  Each spec is a JSON object that looks like


  ```json
  {
    "markdown": "#\tFoo\n",
    "html": "<h1>Foo</h1>\n",
    "example": 10,
    "start_line": 467,
    "end_line": 471,
    "section": "Tabs"
  }
  ```
  """
  use ExUnit.Case

  @test_file "./test/support/commonmark_suite.json"

  specs = @test_file |> File.read!() |> Jason.decode!()

  for {group, specs} <- Enum.group_by(specs, & &1["section"]) do
    describe "\"#{group}\"" do
      for spec <- specs do
        @tag example: spec["example"]
        test "Example ##{spec["example"]}" do
          assert Marx.render(unquote(spec["markdown"])) == unquote(spec["html"])
        end
      end
    end
  end
end
