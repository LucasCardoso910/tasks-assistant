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

function read_file()
{
  local search_tag="${1^^}"
  local found_tag=false

  if [[ -n "$search_tag" ]]; then
    search_tag="$search_tag:"
  fi

  while IFS= read -r line; do
    if [[ -z "$line" ]]; then
      read -r line

      found_tag=false
      if [[ -z "$search_tag" || "$line" = "$search_tag" ]]; then
        found_tag=true
        
        printf "\n"
        colored_print BLUECOLOR "${line^^}"
      fi
    else
      if [[ "$found_tag" = true ]]; then
        printf -- "- %s\n" "$line"
      fi
    fi
  done < "$todo_file"
  printf "\n"
}

function create_tmp_file()
{
  mkdir -p "$tmp"
  > "$next_todo"
}

function save_tmp_file()
{
  mv "$next_todo" "$todo_file"
  rm -rf "$tmp"
}

function add_todo()
{
  local tag="${1^^}"
  local text="$2"
  local found=false

  if [[ -z "$text" ]]; then
    colored_print REDCOLOR "Wrong!"
    printf '%s\n' "Correct usage: assistant todo -a {tag} {text}"
    return 1
  fi

  create_tmp_file

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

  save_tmp_file
}

function delete_todo() 
{
  local tag="${1^^}:"
  local text="$2"
  local found_tag=false
  local found=false

  if [[ -z "$text" ]]; then
    colored_print REDCOLOR "Wrong!"
    printf '%s\n' "Correct usage: assistant todo -d {tag} {text}"
    return 1
  fi

  create_tmp_file

  while IFS= read -r line; do
    if [[ -z "$line" ]]; then
      printf '%s\n' "$line" >> "$next_todo"
      found_tag=false

      read -r line
      if [[ "$tag" = ${line^^} ]]; then
        echo "Found tag!"
        found_tag=true
      fi
    fi

    if [[ "$found_tag" = true ]]; then
      if [[ "$line" = "$text" ]]; then
        read -r line
        found=true
      fi
    fi

    printf '%s\n' "$line" >> "$next_todo"
  done < "$todo_file"

  if [[ "$found" = false ]]; then
    colored_print YELLOWCOLOR "No task with this text in this tag was found!"
    return 2
  fi
  
  save_tmp_file
  check_file
}

function parser_todo()
{
  optstring=acdl
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
    read_file "$1"
  elif [[ $add -gt 0 ]]; then
    add_todo "$@"
  elif [[ $delete -gt 0 ]]; then
    delete_todo "$@"
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
