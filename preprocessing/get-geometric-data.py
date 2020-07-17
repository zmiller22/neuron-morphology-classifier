#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul 17 16:54:01 2020

@author: zack
"""

import pylmeasure as pm
import pandas as pd

import os
from os import listdir
from os.path import isfile, join 

# # Set current location to working directory
# abspath = os.path.abspath(__file__)
# dirname =os.path.dirname(abspath)
# os.chdir(dirname)


# swc_files = [f for f in listdir()]

def getGeometricFeatureDF(input_dir, output_path):
    
    # Get a list of all the .swc files
    swc_files_list = [f for f in listdir(input_dir) if isfile(join(input_dir, f))]
    swc_files_list = [input_dir+"/"+f for f in swc_files_list]
    
    LMfeatures = pm.getMeasure(['Surface', 'Diameter'], swc_files_list)
    
    return LMfeatures
    