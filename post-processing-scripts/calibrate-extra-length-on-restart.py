import re
import sys
import os


def read_file(read_path) -> list:
    try:
        with open(read_path, 'r') as file:
            return file.readlines()

    except FileNotFoundError:
        print(f"The file {file_path} was not found.")

    except Exception as e:
        print(f"An error occurred: {e}")


def write_file(write_path, content):
    try:
        with open(write_path, 'w') as file:
            file.write(''.join(content))

    except FileNotFoundError:
        print(f"The file {file_path} was not found.")

    except Exception as e:
        print(f"An error occurred: {e}")


def modify_restart_distance(content:list):
    # G1 E[0-9.]+ F[0-9]+
    increment = 0.01
    additional_value = 0.0
    for idx,line in enumerate(content, 0):
        line = content[idx]
        if re.search(r"G1 E[0-9.]+ F[0-9]+", line):
            match = re.search(r"G1 E([0-9.]+) F[0-9]+", line)
            e_distance_updated = float(match.group(1)) + additional_value
            additional_value += increment
            new_line = line.replace(match.group(1), str(e_distance_updated))
            content[idx] = new_line

    return content
            


def process_file(input_f):
    content = read_file(input_f)
    modified_content = modify_restart_distance(content)
    write_file(input_f, modified_content)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # Check if a file was provided as an argument
    if len(sys.argv) < 1:
        print("Usage: drag and drop a file onto this script.")
        sys.exit(1)

    # The file path is the first argument
    file_path = sys.argv[1]
    # Call the main processing function
    process_file(file_path)