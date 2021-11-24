from colors import bcolors
import variables
import sys


def add_todo(tag, text):
    found = False

    lines = []
    with open(variables.todo_file, "r") as file:
        lines = file.readlines()

    new_lines = []
    lines_iter = iter(lines)
    for line in lines_iter:
        line = line.rstrip()
        new_lines.append(line + "\n")

        if line:
            continue

        line = next(lines_iter, None)
        if line is None:
            break

        line = line.rstrip()
        new_lines.append(line + "\n")

        if line.upper() == tag:
            line = next(lines_iter, None)

            new_lines.append(text + "\n")
            found = True

            if line is None:
                break

            line = line.rstrip()
            if line != "Empty":
                new_lines.append(line)

    if found is False:
        new_lines.append("\n")
        new_lines.append(tag + "\n")
        new_lines.append(text)

    with open(variables.todo_file, "w") as file:
        file.writelines(new_lines)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"{bcolors.FAIL}Wrong!{bcolors.ENDC}")
        print('Correct usage: assistant todo -a "tag" "text"')
        sys.exit(1)

    tag = sys.argv[1] + ":"
    tag = tag.upper()
    task_text = sys.argv[2]

    add_todo(tag, task_text)
