import chromatic
import gleam/io
import gleam/list
import gleam/string
import glep/error
import glep/find

pub fn print_error(error) {
  io.println(
    "error: "
    |> chromatic.bright_red
    <> error.describe(error)
    <> "\n"
    <> "\n"
    <> "usage: "
    |> chromatic.bright_cyan
    <> "glep [options] <pattern> <file>"
    <> "\n",
  )
}

pub fn print_output(output: find.Output) {
  let header = "--- " <> output.path <> " ---"

  io.println(
    header
    |> chromatic.bright_green
    |> chromatic.bold,
  )

  print_output_loop(output, get_info_padding(output.lines))
}

fn print_output_loop(output: find.Output, info_padding: Int) {
  case output.lines {
    [] -> Nil
    [line, ..rest] -> {
      case output.options.show_all_lines, line {
        True, _ | False, find.MatchingLine(..) ->
          print_line(line, output, info_padding)
        _, _ -> Nil
      }

      print_output_loop(find.Output(..output, lines: rest), info_padding)
    }
  }
}

fn print_line(line, output: find.Output, info_padding: Int) {
  let #(info_color, contents_color) = case line {
    find.MatchingLine(..) -> #(chromatic.bright_yellow, chromatic.clear)
    find.NonMatchingLine(..) -> #(chromatic.black, chromatic.gray)
  }

  let info = {
    let path = case output.options.show_file_names {
      True -> output.path <> ":"
      False -> ""
    }
    let number = string.inspect(line.number)
    let padding =
      "."
      |> string.repeat(info_padding - string.length(number))
      |> chromatic.black

    info_color(path <> number <> padding)
  }

  let contents =
    line.contents
    |> contents_color

  io.println(info <> " " <> contents)
}

fn get_info_padding(lines) {
  lines
  |> list.length
  |> string.inspect
  |> string.length
}
