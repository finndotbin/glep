import gleam/result
import gleam/string
import glep/error

pub type Command {
  Command(options: Options, pattern: String, path: String)
}

pub fn parse(args) {
  case args {
    [unparsed_options, pattern, path] -> {
      use options <- result.try(parse_options(unparsed_options))
      Ok(Command(options: options, pattern: pattern, path: path))
    }
    [pattern, path] -> {
      Ok(Command(options: default_options, pattern: pattern, path: path))
    }
    _ -> Error(error.InvalidArgs)
  }
}

pub type Options {
  Options(show_all_lines: Bool, show_file_names: Bool)
}

const default_options = Options(show_all_lines: False, show_file_names: False)

fn parse_options(unparsed) {
  let first =
    unparsed
    |> string.first
    |> result.unwrap("")
  let rest =
    unparsed
    |> string.drop_left(1)

  case first {
    "-" -> parse_options_loop(rest, default_options)
    invalid -> Error(error.InvalidOption(invalid))
  }
}

fn parse_options_loop(unparsed, options) {
  let first =
    unparsed
    |> string.first
    |> result.unwrap("")
  let rest =
    unparsed
    |> string.drop_left(1)

  case first {
    "a" -> parse_options_loop(rest, Options(..options, show_all_lines: True))
    "f" -> parse_options_loop(rest, Options(..options, show_file_names: True))
    "" -> Ok(options)
    invalid -> Error(error.InvalidOption(invalid))
  }
}
