#! /bin/bash

libdir="lib"
todo_file="$libdir/todo.txt"
srcdir="src"
todo_source="$srcdir/todo.sh"

export libdir
export todo_file
export srcdir
export todo_source

function init()
{
  file_directory=$(dirname ${BASH_SOURCE[0]})
  cd "$file_directory/.."

  mkdir -p lib
  >> $todo_file
}
