#! /bin/bash

libdir="lib"
todo_file="$libdir/todo.txt"
srcdir="src"
todo_source="$srcdir/todo.sh"
tmp=".tmp"
next_todo="$tmp/todo.txt"

export libdir
export todo_file
export srcdir
export todo_source
export tmp
export next_todo

function init()
{
  file_directory=$(dirname ${BASH_SOURCE[0]})
  cd "$file_directory/.."

  mkdir -p "$libdir"
  >> "$todo_file"

  check_file
}

function check_file()
{
  declare -a empty_tags
  local cont=0

  mkdir -p "$tmp"
  > "$next_todo"

  while IFS= read -r line; do
    if [[ -z "$line" ]]; then
      if [[ cont -eq 1 ]]; then
        printf '%s\n' "Empty" >> "$next_todo"
      fi

      cont=0
    else
      cont=$(($cont + 1))
    fi

    printf '%s\n' "$line" >> "$next_todo"
  done < "$todo_file"

  mv "$next_todo" "$todo_file"
  rmdir "$tmp"
}
