from check import check_file
from colors import bcolors
import variables
import sys


def delete_todo(tag, text):
    found_tag = False
    found = False

    if not tag or not text:
        print(f"{bcolors.FAIL}Wrong!{bcolors.ENDC}")
        print('Correct usage: assistant todo -d "tag" "text"')
        return 1

    lines = []
    with open(variables.todo_file, "r") as file:
        lines = file.readlines()

    new_lines = []
    lines_iter = iter(lines)
    for line in lines_iter:
        line = line.rstrip()

        if found_tag is True:
            if line == text:
                found = True
                continue

        if not line:
            new_lines.append(line + "\n")
            found_tag = False

            line = next(lines_iter, None)

            if line is not None:
                line = line.rstrip()

                if tag == line.upper():
                    print("Found tag!")
                    found_tag = True

        new_lines.append(line + "\n")

    if found is False:
        print(
            f"{bcolors.WARNING}No task with this text in this tag was found!{bcolors.ENDC}"
        )
        return 2

    with open(variables.todo_file, "w") as file:
        file.writelines(new_lines)

    check_file()


if __name__ == "__main__":
    tag = sys.argv[1].upper() + ":"
    text = sys.argv[2]
    delete_todo(tag, text)
