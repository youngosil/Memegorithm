import json
import os

with open('./refined.json', 'r', encoding='utf-8-sig') as f:
    json_data = json.load(f)

ocrdict = json_data
newdict = {}
file_path = "./images"
for i in range(1,len(ocrdict)+1):
    try:
        if ocrdict[str(i)]=="":
            #3 45 120 129 160 163 174 297 358 586 797 992
            
            name = str(i)+".jpg"
            src = os.path.join(file_path, name)
            os.remove(src)
        else:
            newdict[i]=ocrdict[str(i)]
    except:
        continue

newocr = dict(sorted(newdict.items()))
print(len(newocr))
with open('rerefined.json', 'w', encoding='UTF-8-sig') as f:
    f.write(json.dumps(newocr, ensure_ascii=False, indent='\t'))