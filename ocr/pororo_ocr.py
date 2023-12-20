from pororo import Pororo
import os
import json
import argparse
from tqdm import tqdm
import warnings
warnings.filterwarnings('ignore')

parser = argparse.ArgumentParser()
parser.add_argument("-d", "--directory", dest="path", action="store")
parser.add_argument("-n", "--name", dest="filename", action="store")
args = parser.parse_args()

ocr = Pororo(task='ocr')

ocr_dict = {}
cnt = 0
for i in tqdm(os.listdir(args.path)):
    path = args.path + '/' + i 
    idx = int(i[:-4])
    try :
        #ocr_dict[i] = ocr(path, detail=True)

        strs = ocr(path, detail=False)
        max_str = max(strs, key=len, default="")
        ocr_dict[idx] = max_str
    except Exception as error: 
        print(f"{i}\t{error}")
        cnt+=1

ocr = dict(sorted(ocr_dict.items()))

with open(str(args.filename)+'.json', 'w', encoding='UTF-8-sig') as f:
    f.write(json.dumps(ocr, ensure_ascii=False, indent='\t'))

print(f"discarded images : {cnt}")