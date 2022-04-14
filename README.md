# Marx

A Markdown compiler for the people.

Supports [CommonMark Version 0.30](https://spec.commonmark.org/0.30/)

## Extensions
* [Github Flavored Markdown](https://github.github.com/gfm/)

## Development

Marx aims to be compliant with the [CommonMark](https://commonmark.org/) specification. Thus, a test suite
against the entire CommonMark specification is included via `MarxConformanceTest`.

### Running a specific conformance example

Each test in the CommonMark test suite is taken from the numbered examples in the spec.
To run a specific test, each test is tagged with the example number. 

``` shell
# Run the test for example five in the CommonMark spec
$ mix test --only example:5
```

### Updating the conformance test suite

1. Clone the [CommonMark spec](https://github.com/commonmark/commonmark-spec)
2. Run `python3 test/spec_tests.py --dump-tests > test/support/commonmark_suite.json`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `marx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:marx, "~> 0.1.0"}
  ]
end
```
