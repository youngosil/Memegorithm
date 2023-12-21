import json
import os
import random
import numpy as np
import cv2
import pickle
from PIL import Image, ImageOps
from collections import Counter
from tqdm import tqdm
from detectron2.data import DatasetCatalog, MetadataCatalog
from detectron2.structures import BoxMode

label_to_class = ['불안', '중립', '당황', '슬픔', '상처', '분노', '기쁨']
class_to_label = {label_to_class[i]: i for i in range(len(label_to_class))}

def get_one_class(root='./dataset', class_name='anger'):
    filenames = os.listdir(os.path.join(root, 'emotion_dataset', 'Validation', f'raw_{class_name}'))
    annotation_list = []
    
    with open(os.path.join(root, 'emotion_dataset', 'Validation', f"label_{class_name}.json")) as f:
        data = json.load(f)
    
    for image_annot in tqdm(data):
        annot_dict = {} # Annotation dictionary for each image
        filename = image_annot['filename']
        annot_dict['file_name'] = os.path.join(root, 'emotion_dataset', 'Validation', f'raw_{class_name}', filename)
        
        # Open image to get width and height
        image = Image.open(os.path.join(root, 'emotion_dataset', 'Validation', f'raw_{class_name}', filename))
        try:
            image = ImageOps.exif_transpose(image)
        except:
            print(f"Error: {filename}")
            continue
        # ./dataset/emotion_dataset/Validation/raw_joy/cdf2646e1aa44d50b273709ec147ed3e8284e967c1808dc6dbb01d47d168e1cd_여_20_기쁨_공공시설&종교&의료시설_20201206201519-001-006.jpg, 
        # got (4032, 2268), expect (2268, 4032). Please check the width/height in your annotation.
        # if filename == 'cdf2646e1aa44d50b273709ec147ed3e8284e967c1808dc6dbb01d47d168e1cd_여_20_기쁨_공공시설&종교&의료시설_20201206201519-001-006.jpg':
        #     breakpoint()
        
        width, height = image.size
        # width, height = np.array(image).shape[1], np.array(image).shape[0]
        annot_dict['width'] = width; annot_dict['height'] = height
        
        # image_id
        annot_dict['image_id'] = filename.split('.')[0]

        # Annotations
        annot_dict['annotations'] = []
        annot_A, annot_B, annot_C = image_annot['annot_A'], image_annot['annot_B'], image_annot['annot_C']

        # Get average bounding box coordinates of 3 annotations
        maxX_average = (annot_A['boxes']['maxX'] + annot_B['boxes']['maxX'] + annot_C['boxes']['maxX']) / 3
        minX_average = (annot_A['boxes']['minX'] + annot_B['boxes']['minX'] + annot_C['boxes']['minX']) / 3
        maxY_average = (annot_A['boxes']['maxY'] + annot_B['boxes']['maxY'] + annot_C['boxes']['maxY']) / 3
        minY_average = (annot_A['boxes']['minY'] + annot_B['boxes']['minY'] + annot_C['boxes']['minY']) / 3

        # Get most voted emotion
        emotion_list = [annot_A['faceExp'], annot_B['faceExp'], annot_C['faceExp']]
        emotion_counter = Counter(emotion_list)
        most_voted_emotion = emotion_counter.most_common(1)[0][0]
        if most_voted_emotion not in label_to_class:
            print(f"Unknown emotion: {most_voted_emotion} -> Changed to '중립'")
            most_voted_emotion = '중립'
        
        # Append annotation
        annot_dict['annotations'].append({
            'bbox': [minX_average, minY_average, maxX_average, maxY_average],
            'bbox_mode': BoxMode.XYXY_ABS,
            'category_id': class_to_label[most_voted_emotion],
            'iscrowd': 0
        })

        annotation_list.append(annot_dict)

    return annotation_list


def read_face_dataset(root='./dataset', use_cache=False):
    if use_cache:
        with open('./data.pkl', 'rb') as f:
            results = pickle.load(f)
        return results
    
    results = []
    for emotion in ['anxious', 'neutral', 'embarassed', 'sad', 'hurt', 'anger', 'joy']:
        # if emotion != 'joy':
        #     continue
        print(f"Processing {emotion}...")
        emotion_result = get_one_class(root, emotion)
        results.extend(emotion_result)

    random.shuffle(results)

    # Split train, validation
    train_size = int(len(results) * 0.9)
    train_results = results[:train_size]
    val_results = results[train_size:]
    
    return {
        "train": train_results,
        "val": val_results,
    }

dataset_trainval = read_face_dataset(use_cache=True)

def get_train_dataset():
    return dataset_trainval['train']

def get_val_dataset():
    return dataset_trainval['val']

DatasetCatalog.register("face_dataset_train", get_train_dataset)
DatasetCatalog.register("face_dataset_val", get_val_dataset)

MetadataCatalog.get("face_dataset_train").thing_classes = ['불안', '중립', '당황', '슬픔', '상처', '분노', '기쁨']
MetadataCatalog.get("face_dataset_val").thing_classes = ['불안', '중립', '당황', '슬픔', '상처', '분노', '기쁨']

# Set evaluator type
MetadataCatalog.get("face_dataset_train").evaluator_type = "coco"
MetadataCatalog.get("face_dataset_val").evaluator_type = "coco"

# DatasetCatalog.register("face_dataset", read_face_dataset)
# MetadataCatalog.get("face_dataset").thing_classes = ['불안', '중립', '당황', '슬픔', '상처', '분노', '기쁨']
