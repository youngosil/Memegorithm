import requests
import json 
from sentence_transformers import SentenceTransformer, util
import numpy as np
import pickle
import argparse

# target sentence
targetsent = []
targetsent.append(input())

# get arguments
parser = argparse.ArgumentParser()
parser.add_argument("-o", "--ocrfile", dest="ocrpath", action="store")
parser.add_argument("-e", "--embedfile", dest="embedpath", action="store")
args = parser.parse_args()

# get embedded sentences
with open(args.ocrpath, 'r', encoding='utf-8-sig') as f:
    json_data = json.load(f)
with open(args.embedpath, 'rb') as f:
    embeddings = pickle.load(f)

# model & embedding
model = SentenceTransformer('snunlp/KR-SBERT-V40K-klueNLI-augSTS')

targetembedding = model.encode(targetsent)

cosine_scores = util.cos_sim(targetembedding, embeddings)
scores = cosine_scores[0].tolist()

maxidx = scores.index(max(scores))
print(maxidx)
print(max(scores))
print(json_data[str(maxidx)])