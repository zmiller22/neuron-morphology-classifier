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

def getGeometricFeatureDF(input_dir, output_path=0):
    """Function to read in all neurons in a directory, extract their geometric
    features using L-measure"""
    #TODO add ability to choose individual features and add the rest of the 
    # L-measure features
    
    # Get a list of all the .swc files
    swc_files_list = [f for f in listdir(input_dir) if isfile(join(input_dir, f))]
    swc_files_list = [input_dir+"/"+f for f in swc_files_list]
    
    # Get all the features desired
    total_feature_names = ["N_stems", "N_bifs", "N_branch", 
                           "N_tips", "Length", "TerminalSegment"]
    avg_feature_names = ["EucDistance", "PathDistance", "Branch_Order",
                         "Terminal_degree"]
    feature_names = total_feature_names+avg_feature_names
    
    # Calculate all the features
    LMfeatures = pm.getMeasure(feature_names, swc_files_list)
    
    # Put extracted features into a dataframe
    df = pd.DataFrame()
    for i, feature in enumerate(LMfeatures):
        
        feature_dict = feature["WholeCellMeasuresDict"]
        
        if feature_names[i] in avg_feature_names:
            nrn_feature_list = [nrn["Average"] for nrn in feature_dict]
            df[ feature_names[i] ] = nrn_feature_list
        elif feature_names[i] in total_feature_names:
            nrn_feature_list = [nrn["TotalSum"] for nrn in feature_dict]
            df[ feature_names[i] ] = nrn_feature_list
            
    # Set the dataframe names to be the neuron names
    row_names = [os.path.basename(path).strip(".swc") for path in swc_files_list]
    df.index = row_names
    
    # Write dataframe to output csv
    if output_path!=0:
        df.to_csv(output_path)
    
    
    return df
    
#%%
# test = getGeometricFeatureDF("/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/testing/test_nrns", 
#                              "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/testing/test.csv")

#%%
# df = pd.DataFrame()
# for i, feature in enumerate(test):
#     feature_dict = feature["WholeCellMeasuresDict"]
#     nrn_feature_list = [nrn["Average"] for nrn in feature_dict]
    
#     df[ feature_names[i] ] = nrn_feature_list