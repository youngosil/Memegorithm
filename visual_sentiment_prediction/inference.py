import logging
import os
import torch
import detectron2
import numpy as np
import pandas as pd
from PIL import Image
from detectron2 import model_zoo
from detectron2.utils.logger import setup_logger
from detectron2.utils.visualizer import ColorMode, Visualizer
import cv2
import detectron2.utils.comm as comm
from detectron2.checkpoint import DetectionCheckpointer, PeriodicCheckpointer
from detectron2.config import get_cfg
from detectron2.data import (build_detection_test_loader,build_detection_train_loader,)
from detectron2.engine import default_writers
from detectron2.evaluation import (COCOEvaluator,inference_on_dataset)
from detectron2.modeling import build_model
from detectron2.solver import build_lr_scheduler, build_optimizer
from detectron2.utils.events import EventStorage
from detectron2.data.datasets import register_coco_instances
from detectron2.data import DatasetCatalog, MetadataCatalog
from detectron2.engine import DefaultPredictor
from tqdm import tqdm
from torch.utils import tensorboard
from detectron2.engine import default_argument_parser, default_setup, launch
# from utility import load_dataset

setup_logger()

def setup(args):
    """
    Create configs and perform basic setups.
    """
    cfg = get_cfg()
    cfg.merge_from_file(args.config_file)
    cfg.merge_from_list(args.opts)
    cfg.freeze()
    default_setup(
        cfg, args
    )  # if you don't like any of the default setup, write your own setup code
    return cfg


args = default_argument_parser().parse_args()
cfg = setup(args)

predictor = DefaultPredictor(cfg)
checkpointer = DetectionCheckpointer(predictor.model)
checkpointer.load('output/model_0089999.pth')
image_path = './samples/hello.jpg'

image = cv2.imread(image_path)
outputs = predictor(image)
# Visualize the predictions (optional)
v = Visualizer(image[:, :, ::-1],
                metadata=None,  # Use the metadata of your training set for visualization
                scale=0.8,
                instance_mode=ColorMode.IMAGE   # Removes the color of unsegmented pixels
)
v = v.draw_instance_predictions(outputs["instances"][0].to("cpu"))
result_image = v.get_image()[:, :, ::-1]
Image.fromarray(result_image).save(f'qwe.png')
