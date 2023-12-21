import requests
import json 
from sentence_transformers import SentenceTransformer, util
import numpy as np
import pickle

class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)

# get dataset
with open('./ocr/finalocr.json', 'r', encoding='utf-8-sig') as f:
    json_data = json.load(f)
ocrsent = json_data
sentences = list(ocrsent.values())

# model & embedding
model = SentenceTransformer('snunlp/KR-SBERT-V40K-klueNLI-augSTS')

embeddings = model.encode(sentences)
embeddingdict={}
for i in range(len(sentences)):
    embeddingdict[i] = {"ocr": sentences[i], "embedding": embeddings[i]}

# save
with open('sentembeddings.json', 'w', encoding='UTF-8-sig') as f:
    f.write(json.dumps(embeddingdict, ensure_ascii=False, indent='\t', cls=NumpyEncoder))

# save - pickle
with open('sentembeddings.pickle', 'wb') as f:
    pickle.dump(embeddings, f)