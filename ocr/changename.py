import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-d", "--directory", dest="path", action="store")
args = parser.parse_args()


# 주어진 디렉토리에 있는 항목들의 이름을 담고 있는 리스트를 반환합니다.
# 리스트는 임의의 순서대로 나열됩니다.
file_names = os.listdir(args.path)
file_names

i = 1
for name in file_names:
    src = os.path.join(args.path, name)
    dst = str(i) + '.jpg'
    dst = os.path.join(args.path, dst)
    os.rename(src, dst)
    i += 1