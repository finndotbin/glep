import simplifile

pub type GlepError {
  FileError(simplifile.FileError)
  InvalidArgs
  InvalidOption(String)
}

pub fn describe(error) {
  case error {
    FileError(file_error) ->
      "file error: " <> simplifile.describe_error(file_error)
    InvalidArgs -> "invalid arguments"
    InvalidOption(option) -> "invalid option: '-" <> option <> "'"
  }
}
