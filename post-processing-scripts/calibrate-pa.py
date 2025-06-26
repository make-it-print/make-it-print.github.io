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

def is_object_start(line:str):
    return line.startswith("EXCLUDE_OBJECT_START")

def is_layer_change(line:str):
    return line.startswith(";LAYER_CHANGE")

def is_set_pa(line:str):
    return line.startswith("SET_PRESSURE_ADVANCE ADVANCE=")

def modify_restart_distance(content:list):
    paTower = True
    start_layer = 2
    start_pa = 0.0
    increment = 0.01

    layer_index = 0
    current_pa = start_pa
    layer_count = 0
    idx = 0
    while idx < len(content):
        line = content[idx]

        if is_layer_change(line):
            layer_index += 1
            layer_count += 1

        if layer_index < start_layer:
            idx += 1
            continue
        
        if is_set_pa(line):
            new_pa = "SET_PRESSURE_ADVANCE ADVANCE=" + str(current_pa) + "\n"
            content[idx] = new_pa

        if paTower and is_layer_change(line):
            if layer_count > 5:
                layer_count = 0
                current_pa += increment
            content.insert(idx + 1, "SET_PRESSURE_ADVANCE ADVANCE=" + str(current_pa) + "\n")

        if not paTower:
            if is_layer_change(line):
              current_pa = start_pa

            if is_object_start(line):
                current_pa += increment
                content.insert(idx + 1, "SET_PRESSURE_ADVANCE ADVANCE=" + str(current_pa) + "\n")

        idx += 1

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