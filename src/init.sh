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

  mkdir -p lib
  >> $todo_file
}
