import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-d", "--directory", dest="path", action="store")
args = parser.parse_args()

original_file_path = "./images_final/"
new_file_path = "./imgs/"

original_file_names = os.listdir(original_file_path)
new_file_names = os.listdir(new_file_path)

print(original_file_names[:4])
print(new_file_names[:4])

for name in new_file_names:
    if name in original_file_names:
        src = os.path.join(new_file_path, name)
        os.remove(src)