import os
import models
import sys

sys.setrecursionlimit(10000)

def read_swc_file(swc_file_path):
    swc_file = open(swc_file_path, 'r')
    neuron = models.Neuron(nodes=[])
    neuron.name = os.path.basename(swc_file_path)
    for line in swc_file:
        if not line.__contains__('#'):
            try:
                input_data = line.replace('\n', '').split(' ')
                parent_id = int(input_data[6])
                parent = neuron.get_node_by_id(parent_id)

                node = models.Node(id=int(input_data[0]),
                                   type=0,
                                   x=float(input_data[2]),
                                   y=float(input_data[3]),
                                   z=float(input_data[4]),
                                   r=float(input_data[5]),
                                   parent=parent)
                if parent:
                    parent.children.append(node)

                neuron.add_node(node)
            except:
                print(line)

    neuron.initialize()

    return neuron


def export_neuron_to_swc(neuron, file_path):
    file = open(file_path, 'w')
    file.write('# Generated by Max Planck Institute \n')

    for node in neuron.nodes:
        current_line = node.id.__str__() + ' '
        current_line += '0 '
        current_line += node.position.x.__str__() + ' '
        current_line += node.position.y.__str__() + ' '
        current_line += node.position.z.__str__() + ' '
        current_line += node.radius.__str__() + ' '

        if node.parent:
            current_line += node.parent.id.__str__() + '\n'
        else:
            current_line += '-1' + '\n'

        file.write(current_line)

    file.close()


def unify_nodes_radius(swc_file_path, radius, output_file_path):
    neuron = read_swc_file(swc_file_path)
    for node in neuron.nodes:
        node.radius = radius

    export_neuron_to_swc(neuron, output_file_path)


# output_folder = 'C:\\Users\\nmokayes\\Desktop\\unified_radius'
# input_folder = 'C:\\Users\\nmokayes\\Desktop\\fugima_in_tectum\\media\\data\\neurons'
# for file_name in os.listdir(input_folder):
#     if file_name.endswith('.swc'):
#         # try:
#         input_file = os.path.join(input_folder, file_name)
#         output_file = os.path.join(output_folder, file_name)
#         unify_nodes_radius(input_file, 1, output_file)
        # except:
        #     continue


# file = 'C:\\Users\\nmokayes\\Desktop\\FT_T_mdG-L1.swc'
# neuron = read_swc_file(file)
# x=0
