import gleam/list
import gleam/result
import gleam/string
import glep/command
import glep/error
import simplifile

pub type Output {
  Output(options: command.Options, path: String, lines: List(Line))
}

pub type Line {
  MatchingLine(contents: String, number: Int)
  NonMatchingLine(contents: String, number: Int)
}

pub fn find(cmd: command.Command) -> Result(Output, error.GlepError) {
  cmd.path
  |> simplifile.read
  |> result.map(fn(text) {
    Output(
      options: cmd.options,
      path: cmd.path,
      lines: to_lines(text, cmd.pattern),
    )
  })
  |> result.map_error(fn(err) { error.FileError(err) })
}

fn to_lines(text, pattern) {
  text
  |> string.split("\n")
  |> list.index_map(fn(contents, index) {
    let number = index + 1

    case
      contents
      |> string.contains(pattern)
    {
      True -> MatchingLine(contents: contents, number: number)
      False -> NonMatchingLine(contents: contents, number: number)
    }
  })
}
