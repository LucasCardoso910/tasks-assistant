from colors import bcolors
import variables
import sys


def read_file(search_tag):
    found_tag = False

    if search_tag:
        search_tag += ":"

    with open(variables.todo_file, "r") as file:
        file_iterator = iter(file)

        for line in file_iterator:
            line = line.rstrip()

            if not line:
                line = next(file_iterator).rstrip()
                found_tag = False

                if (not search_tag) or (line == search_tag):
                    found_tag = True
                    line = line.upper()

                    print(f"\n{bcolors.HEADER}{line}{bcolors.ENDC}")
            elif found_tag:
                print(f"- {line}")
    print("")


if __name__ == "__main__":
    if len(sys.argv) > 2:
        sys.exit(1)

    search_tag = ""
    if len(sys.argv) == 2:
        search_tag = sys.argv[1].upper()

    read_file(search_tag)
