import requests
import json 
from sentence_transformers import SentenceTransformer, util
import numpy as np
import pickle
import argparse

def calculatesim(target):
    targets = []
    targets.append(target)

    ocrembpath = './checkpoints/ocr_embeddings.pickle'
    capembpath = './checkpoints/caption_embeddings.pickle'
    ocrcapembpath = './checkpoints/ocr_caption_embeddings.pickle'

    with open(ocrembpath, 'rb') as f:
        ocrembeddings = pickle.load(f)
    with open(capembpath, 'rb') as f:
        capembeddings = pickle.load(f)
    with open(ocrcapembpath, 'rb') as f:
        ocrcapembeddings = pickle.load(f)

    # model & embedding
    model = SentenceTransformer('snunlp/KR-SBERT-V40K-klueNLI-augSTS')

    targetembedding = model.encode(targets)

    ocrresults = util.semantic_search(targetembedding, ocrembeddings, top_k=5)
    capresults = util.semantic_search(targetembedding, capembeddings, top_k=5)
    ocrcapresults = util.semantic_search(targetembedding, ocrcapembeddings, top_k=5)

    outidxlist = [513, 514, 460, 613, 704, 783, 842, 856, 895, 1108]

    ocrresult = ocrresults[0][0]
    capresult = capresults[0][0]
    ocrcapresult = ocrcapresults[0][0]
    
    i=0
    while ocrresult['corpus_id'] in outidxlist:
        i += 1
        if i==5:
            ocrresults[0][0]
            break
        ocrresult = ocrresults[0][i]
    
    i=0
    while capresult['corpus_id'] in outidxlist:
        i += 1
        if i==5:
            capresult = capresult[0][0]
            break
        capresult = capresult[0][i]
    
    i=0
    while ocrcapresult['corpus_id'] in outidxlist:
        i += 1
        if i==5:
            ocrcapresult = ocrcapresults[0][0]
            break
        ocrcapresult = ocrcapresult[0][i]['corpus_id']
    
    returndata = {}
    returndata['ocr'] = (str(ocrresult['corpus_id']), ocrresult['score'])
    returndata['caption'] = (str(capresult['corpus_id']), capresult['score'])
    returndata['ocr_caption'] = (str(ocrcapresult['corpus_id']), ocrcapresult['score'])
    return returndata

