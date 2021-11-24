#! /bin/bash

declare -gr BLUECOLOR='\033[1;34;49m%s\033[m'
declare -gr REDCOLOR='\033[1;31;49m%s\033[m'
declare -gr YELLOWCOLOR='\033[1;33;49m%s\033[m'
declare -gr GREENCOLOR='\033[1;32;49m%s\033[m'

declare -A lines

## Global variables
list=0
delete=0
add=0

function colored_print()
{
  local message="${*:2}"
  local colored_format="${!1}"

  if [[ $# -ge 2 && $2 = '-n' ]]; then
    message="${*:3}"
    if [ -t 1 ]; then
      printf "$colored_format" "$message"
    else
      printf '%s' "$message"
    fi
  else
    if [ -t 1 ]; then
      printf "$colored_format\n" "$message"
    else
      printf '%s\n' "$message"
    fi
  fi

  return 0
}

function save_tmp_file()
{
  mv "$next_todo" "$todo_file"
  rm -rf "$tmp"
}

function parser_todo()
{
  optstring=adl
  while getopts $optstring opt; do
    case $opt in
      a) add=$(($add + 1)) ;;
      d) delete=$(($delete + 1)) ;;
      l) list=$(($list + 1)) ;;
      *) return 2 ;;
    esac
  done
}

function todo()
{
  parser_todo "$@"
  shift "$(($OPTIND - 1))"

  if [[ $list -gt 0 ]]; then
    python3 "$read_file" "$1"
  elif [[ $add -gt 0 ]]; then
    python3 "$add_todo" "$@"
  elif [[ $delete -gt 0 ]]; then
    python3 "$delete_todo" "$@"
  else
    printf "No valid option!\n"
    printf "Try these:\n"
    printf "\t-a: add a new todo\n"
    printf "\t-d: delete a existing todo\n"
    printf "\t-l: list all todo activities\n"
    printf "\n"
  fi

  return "$?"
}
