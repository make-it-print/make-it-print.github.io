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

def collect_object_names(content: list) -> list:
    """Collect all object names from EXCLUDE_OBJECT_DEFINE lines."""
    object_names = []
    for line in content:
        if line.startswith("EXCLUDE_OBJECT_DEFINE NAME="):
            # Extract the object name
            match = re.search(r"EXCLUDE_OBJECT_DEFINE NAME=(\S+)", line)
            if match:
                object_name = match.group(1)
                object_names.append(object_name)
    return object_names

def modify_pa(content:list):
    paTower = False
    start_layer = 0
    start_pa = 0.0
    increment = 0.005

    layer_index = 0
    current_pa = start_pa
    layer_count = 0
    
    # Collect objects and assign PA values if not paTower
    object_pa_map = {}
    if not paTower:
        object_names = collect_object_names(content)
        for i, obj_name in enumerate(object_names):
            # First object gets start_pa, rest increase progressively
            object_pa_map[obj_name] = start_pa + (i * increment)
    
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
            if is_object_start(line):
                # Extract object name from EXCLUDE_OBJECT_START
                match = re.search(r"EXCLUDE_OBJECT_START NAME=(\S+)", line)
                if match:
                    obj_name = match.group(1)
                    # Set current_pa based on object name
                    if obj_name in object_pa_map:
                        current_pa = object_pa_map[obj_name]
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
            

def modify_first_layer_travel_accel(content: list):
    start_layer_index = 1
    layer_index = 0
    idx = 0

    travel_pattern = re.compile(r"^G1\s+X[-0-9.]+\s+Y[-0-9.]+.*F48000")
    deretraction_pattern = re.compile(r"^G1\s+E([0-9.]+)\s+F2400")

    prior_velocity_block = []
    prev_was_velocity = False

    while idx < len(content):
        line = content[idx]

        is_velocity_line = line.startswith("SET_VELOCITY_LIMIT ")
        if is_velocity_line:
            if not prev_was_velocity:
                prior_velocity_block = []
            prior_velocity_block.append(line)
            prev_was_velocity = True
        else:
            prev_was_velocity = False

        if is_layer_change(line):
            layer_index += 1

        if layer_index == start_layer_index:
            if travel_pattern.match(line):
                # Look ahead a small window to find deretraction after travel
                deretraction_index = None
                lookahead_limit = 5
                la = 1
                while la <= lookahead_limit and (idx + la) < len(content):
                    next_line = content[idx + la]
                    m = deretraction_pattern.match(next_line)
                    if m:
                        try:
                            e_val = float(m.group(1))
                        except ValueError:
                            e_val = 0.0
                        if e_val > 0:
                            deretraction_index = idx + la
                            break
                    la += 1

                if deretraction_index is not None:
                    content.insert(idx, "SET_VELOCITY_LIMIT ACCEL=12000 ACCEL_TO_DECEL=3000 SQUARE_CORNER_VELOCITY=12\n")
                    idx += 1
                    if prior_velocity_block:
                        insert_pos = deretraction_index + 2
                        for vline in prior_velocity_block:
                            content.insert(insert_pos, vline)
                            insert_pos += 1

        idx += 1

    return content


def process_file(input_f):
    content = read_file(input_f)
    # First fix first-layer travel acceleration
    content = modify_first_layer_travel_accel(content)
    # Then apply PA modifications (if enabled)
    # content = modify_pa(content)
    # modified_content = override_pa(content)
    # modified_content = modify_z_offset(content)
    # modified_content = modify_pa_smooth_time(content)
    # modified_content = modify_square_corner_velocity(content)
    # modified_content = modify_accel(content)
    write_file(input_f, content)


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