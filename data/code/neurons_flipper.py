import os

import shutil

from models import *
from swc_controller import *


def flip_neuron(original_neuron, flipping_center_x, dest_file_path):
    dest_file = open(dest_file_path, 'w')

    for node in original_neuron.nodes:
        flipped_x = (2 * flipping_center_x) - node.position.x
        if node.parent:
            line = str(node.id) + ' 0 ' + str(flipped_x) + ' ' + str(node.position.y) + ' ' + str(
                node.position.z) + ' ' + str(node.radius) + ' ' + str(node.parent.id) + '\n'
        else:
            line = str(node.id) + ' 1 ' + str(flipped_x) + ' ' + str(node.position.y) + ' ' + str(
                node.position.z) + ' ' + str(node.radius) + ' -1' + '\n'
        dest_file.write(line)
    dest_file.close()


def flip_neurons(root, to_right, to_left, detection_center_x, flipping_center_x):
    counter = len(os.listdir(root_dir))
    for file_name in os.listdir(root):
        print counter
        counter -= 1
        if file_name.endswith('.swc'):
            src_swc_file = os.path.join(root, file_name)
            original_neuron = read_swc_file(src_swc_file)
            if original_neuron.soma.position.x < detection_center_x:
                dest_swc_file_path = os.path.join(to_right, file_name)
            else:
                dest_swc_file_path = os.path.join(to_left, file_name)
            flip_neuron(original_neuron, flipping_center_x, dest_swc_file_path)


def flip_neuron__z(original_neuron, max_z, dest_file_path):
    dest_file = open(dest_file_path, 'w')

    for node in original_neuron.nodes:
        flipped_z = max_z - node.position.z
        if node.parent:
            line = str(node.id) + ' 0 ' + str(node.position.x) + ' ' + str(node.position.y) + ' ' + str(
                flipped_z) + ' ' + str(node.radius) + ' ' + str(node.parent.id) + '\n'
        else:
            line = str(node.id) + ' 1 ' + str(node.position.x) + ' ' + str(node.position.y) + ' ' + str(
                flipped_z) + ' ' + str(node.radius) + ' -1' + '\n'
        dest_file.write(line)
    dest_file.close()


def flip_neurons__z(root, flipped_dir, max_z):
    counter = len(os.listdir(root))
    for file_name in os.listdir(root):
        print counter
        counter -= 1
        if file_name.endswith('.swc'):
            src_swc_file = os.path.join(root, file_name)
            original_neuron = read_swc_file(src_swc_file)
            dest_swc_file_path = os.path.join(flipped_dir, file_name)
            flip_neuron__z(original_neuron, max_z, dest_swc_file_path)


def sort_files(root, left_folder, right_folder):
    for file_name in os.listdir(root):
        if file_name.endswith('.swc'):
            file = os.path.join(root, file_name)
            neuron = read_swc_file(file)
            if neuron.soma.position.x < DETECTION_CENTER_X:
                new_file = os.path.join(left_folder, file_name)
            else:
                new_file = os.path.join(right_folder, file_name)

            shutil.move(file, new_file)


DETECTION_CENTER_X = 284
FLIPPING_CENTER_X = 298.5

root_dir = 'neurons/original'
to_left = 'neurons/to_left'
to_right = 'neurons/to_right'


flip_neurons(root_dir, to_right, to_left, DETECTION_CENTER_X, FLIPPING_CENTER_X)
