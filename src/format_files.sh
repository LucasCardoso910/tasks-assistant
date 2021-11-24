#!/bin/bash

function format_files()
{
  # Formatting Bash files
  for file in src/*.sh; do
    shfmt -w -i=2 -ln=bash -fn -ci -sr "$file"
  done

  # Formatting Python files
  for file in src/*.py; do
    black "$file" 2> /dev/null
  done

  # Format main file
  shfmt -w -i=2 -ln=bash -fn -ci -sr assistant
}
