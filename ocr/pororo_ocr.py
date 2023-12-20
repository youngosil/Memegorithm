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
    try :
        path = args.path + '/' + i 
        idx = int(i[:-4])
        
        ocrresult = ocr(path, detail=True)

        if len(ocrresult["bounding_poly"])==0:
            
            ocr_dict[idx]=""
        elif len(ocrresult["bounding_poly"])==1:
            ocr_dict[idx] = ocrresult["bounding_poly"][0]["description"]
        else:
            maxsurf = 0
            maxidx = 0
            for j in range(len(ocrresult)):
                x0 = ocrresult["bounding_poly"][j]["vertices"][0]["x"]
                y0 = ocrresult["bounding_poly"][j]["vertices"][0]["y"]
                x1 = ocrresult["bounding_poly"][j]["vertices"][2]["x"]
                y1 = ocrresult["bounding_poly"][j]["vertices"][2]["y"]

                width = x1-x0
                height = y1-y0

                surface = width*height
                if surface > maxsurf:
                    maxsurf = surface
                    maxidx = j
            ocr_dict[idx] = ocrresult["bounding_poly"][j]["description"]

        #strs = ocr(path, detail=False)
        #max_str = max(strs, key=len, default="")
        #ocr_dict[idx] = max_str
    except Exception as error: 
        print(f"{i}\t{error}")
        cnt+=1

ocr = dict(sorted(ocr_dict.items()))

with open(str(args.filename)+'.json', 'w', encoding='UTF-8-sig') as f:
    f.write(json.dumps(ocr, ensure_ascii=False, indent='\t'))

print(f"discarded images : {cnt}")