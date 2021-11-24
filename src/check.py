import variables


def check_file():
    count = 0

    with open(variables.todo_file, "r") as file:
        lines = file.readlines()

    new_lines = []
    for line in lines:
        line = line.rstrip()

        if not line:
            if count == 1:
                new_lines.append("Empty\n")
            count = 0
        else:
            count += 1

        new_lines.append(line + "\n")

    if count == 1:
        new_lines.append("Empty\n")

    with open(variables.todo_file, "w") as file:
        file.writelines(new_lines)
