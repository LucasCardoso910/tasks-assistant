#! /bin/bash

declare -gr BLUECOLOR='\033[1;34;49m%s\033[m'
declare -gr REDCOLOR='\033[1;31;49m%s\033[m'
declare -gr YELLOWCOLOR='\033[1;33;49m%s\033[m'
declare -gr GREENCOLOR='\033[1;32;49m%s\033[m'

## Global variables
list=0

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

function parser_todo()
{
  optstring=l
  while getopts $optstring opt; do
    case $opt in
      l) list=$(($verbose + 1)) ;;
      *) return 2 ;;
    esac
  done
  shift "$(($OPTIND - 1))"
}

function todo()
{
  parser_todo $@

  if [[ $list -gt 0 ]]; then
    read_file
  else
    printf "No valid option!\n"
    printf "Try these:\n"
    printf "\t-l: list all todo activities\n"
  fi

  return "$?"
}
