#! /bin/bash

declare -gr BLUECOLOR='\033[1;34;49m%s\033[m'
declare -gr REDCOLOR='\033[1;31;49m%s\033[m'
declare -gr YELLOWCOLOR='\033[1;33;49m%s\033[m'
declare -gr GREENCOLOR='\033[1;32;49m%s\033[m'

declare -A tags

## Global variables
list=0
add=0

function prep()
{
  file_directory=$(dirname ${BASH_SOURCE[0]})
  cd "$file_directory/.."

  mkdir -p "$libdir"
}

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

function read_file()
{
  while IFS= read -r line; do
    if [[ -z "$line" ]]; then
      read -r line
      printf "\n"
      colored_print BLUECOLOR "${line^^}"
    else
      printf -- "- %s\n" "$line"
    fi
  done < "$todo_file"
  printf "\n"
}

function add_todo()
{
  local tag="${1^^}"
  local text="$2"
  local found=false

  if [[ -z "$tag" || -z "$text" ]]; then
    colored_print REDCOLOR "Wrong!"
    printf '%s\n' "Correct usage: assistant todo -a {tag} {text}"
    return 1
  fi

  mkdir -p $tmp
  > "$next_todo"

  while IFS= read -r line; do
    printf '%s\n' "$line" >> "$next_todo"

    if [[ -z "$line" ]]; then
      read -r line
      printf '%s\n' "$line" >> "$next_todo"

      if [[ "${line^^}" = "${tag}:" ]]; then
        printf '%s\n' "$text" >> "$next_todo"
        found=true
      fi
    fi
  done < "$todo_file"

  if [[ "$found" = false ]]; then
    printf '\n' >> "$next_todo"
    printf '%s:\n' "$tag" >> "$next_todo"
    printf '%s\n' "$text" >> "$next_todo"
  fi

  mv "$next_todo" "$todo_file"
  rm -rf $tmp
}

function parser_todo()
{
  optstring=al
  while getopts $optstring opt; do
    case $opt in
      a) add=$(($add + 1)) ;;
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
    read_file
  elif [[ $add -gt 0 ]]; then
    add_todo "$@"
  else
    printf "No valid option!\n"
    printf "Try these:\n"
    printf "\t-l: list all todo activities\n"
    printf "\t-a: add a new todo\n"
    printf "\n"
  fi

  return "$?"
}
