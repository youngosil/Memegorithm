import json
import os

with open('./ocr/refined.json', 'r', encoding='utf-8-sig') as f:
    json_data = json.load(f)

ocrdict = json_data
file_path = "./images"
for i in range(1,len(ocrdict)):
    if ocrdict[str(i)]=="":
        #3 45 120 129 160 163 174 297 358 586 797 992
        
        name = str(i)+".jpg"
        src = os.path.join(file_path, name)
        os.remove(src)