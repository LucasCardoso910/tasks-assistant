from check import check_file
import variables
import os


def init():
    if not os.path.isdir(variables.libdir):
        os.mkdir(variables.libdir)

    # Creates file if it doesn't exist already
    with open(variables.todo_file, "a") as file:
        pass

    check_file()


if __name__ == "__main__":
    init()
