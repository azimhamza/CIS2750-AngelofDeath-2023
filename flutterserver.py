import os

def read_sdf_file(filename):
    with open(filename, 'r') as file:
        file_contents = file.read()
    return file_contents

# # Example usage:
# filename = "example.sdf"  # Replace with your SDF file name
# file_contents = read_sdf_file(filename)
# print(file_contents)

