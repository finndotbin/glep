# glep

Glep is a command-line tool written in [Gleam](https://gleam.run/) that's used to recursively search for patterns within files.

```sh
# Search for all occurrences of '.' in glep.gleam.
# -a  Show all files, even non-matching ones
# -f  Show file names before line numbers
glep -af '.' src/glep.gleam
```
