#c:\Python312\python.exe C:\Sources\make-it-print.github.io\post-processing-scripts\calibrate-pa.py;

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

def is_pa_pattern_start(line:str):
    return line.startswith("; start pressure advance pattern for layer")

def is_layer_change(line:str):
    return line.startswith(";LAYER_CHANGE")

def is_set_pa(line:str):
    return line.startswith("SET_PRESSURE_ADVANCE ADVANCE=")

def is_set_pa_value(line: str, pa: float) -> bool:
    if line.startswith("SET_PRESSURE_ADVANCE ADVANCE="):
        # Extract the Z value from the line
        match = re.search(r"SET_PRESSURE_ADVANCE ADVANCE=([0-9.]+);", line)
        if match:
            currentPa = float(match.group(1))
            # Compare the extracted Z value with the provided z_offset
            return abs(currentPa - pa) < 1e-6  # Using small epsilon for float comparison
    return False

def is_set_z(line: str, z_offset: float) -> bool:
    if line.startswith("G1 Z"):
        # Extract the Z value from the line
        match = re.search(r"G1 Z([0-9.]+)", line)
        if match:
            z_value = float(match.group(1))
            # Compare the extracted Z value with the provided z_offset
            return abs(z_value - z_offset) < 1e-6  # Using small epsilon for float comparison
    return False

def modify_pa(content:list):
    paTower = False
    start_layer = 2
    start_pa = 0
    increment = 0.005

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

def override_pa(content:list):
    targetPa = 0.8
    start_layer = 2
    start_pa = 0.3
    increment = 0.1

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
        
        if is_set_pa_value(line, targetPa):
            new_pa = "SET_PRESSURE_ADVANCE ADVANCE=" + str(current_pa) + "\n"
            content[idx] = new_pa


        if is_layer_change(line):
            current_pa = start_pa

        if is_object_start(line):
            current_pa += increment

        idx += 1

    return content

def modify_z_offset(content:list):
    startZ = 0.2
    increment = 0.01

    currentZ = startZ
    idx = 0
    while idx < len(content):
        line = content[idx]
        
        if is_set_z(line, 0.3):
            new_z = "G1 Z" + str(currentZ) + "\n"
            content[idx] = new_z
        
        if is_object_start(line):
            currentZ += increment

        idx += 1

    return content

def modify_pa_smooth_time(content:list):
    startValue = 0.04
    increment = -0.01

    currentValue = startValue
    idx = 0
    while idx < len(content):
        line = content[idx]

        if is_layer_change(line):
          currentValue = startValue
        
        if is_pa_pattern_start(line):
          currentValue += increment

          content.insert(idx + 1, "SET_PRESSURE_ADVANCE SMOOTH_TIME=" + str(currentValue) + "\n")

        idx += 1

    return content

def modify_square_corner_velocity(content:list):
    startValue = -5
    increment = 10

    currentValue = startValue
    idx = 0
    while idx < len(content):
        line = content[idx]

        if is_layer_change(line):
          currentValue = startValue
        
        if is_pa_pattern_start(line):
          currentValue += increment

          content.insert(idx + 1, "SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=" + str(currentValue) + "\n")

        idx += 1

    return content

def modify_accel(content:list):
    startValue = 5000
    increment = -1000

    currentValue = startValue
    idx = 0
    while idx < len(content):
        line = content[idx]

        if is_layer_change(line):
          currentValue = startValue
        
        if is_pa_pattern_start(line):
          currentValue += increment
          accel_to_decel = int(currentValue * 0.5)

          content.insert(idx + 1, "SET_VELOCITY_LIMIT ACCEL=" + str(currentValue) + " ACCEL_TO_DECEL=" + str(accel_to_decel) + "\n")

        idx += 1

    return content
            


def process_file(input_f):
    content = read_file(input_f)
    modified_content = modify_pa(content)
    # modified_content = override_pa(content)
    # modified_content = modify_z_offset(content)
    # modified_content = modify_pa_smooth_time(content)
    # modified_content = modify_square_corner_velocity(content)
    # modified_content = modify_accel(content)

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