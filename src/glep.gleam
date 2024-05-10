import argv
import gleam/result
import glep/command
import glep/find
import glep/print

pub fn main() {
  case
    argv.load().arguments
    |> run
  {
    Ok(output) -> {
      print.print_output(output)
      Nil
    }
    Error(err) -> {
      print.print_error(err)
    }
  }
}

pub fn run(args) {
  use cmd <- result.try(command.parse(args))
  find.find(cmd)
}
