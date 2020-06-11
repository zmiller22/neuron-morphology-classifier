import collections
import math
import numpy as np

round_digits = 4


class Vector:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def __add__(self, other):
        self.x += other.x
        self.y += other.y
        self.z += other.z

        self.round()

    def __sub__(self, other):
        self.x -= other.x
        self.y -= other.y
        self.z -= other.z

        self.round()

    def __div__(self, number):
        self.x /= number
        self.y /= number
        self.z /= number

        self.round()

    def __str__(self):
        return 'X = ' + self.x.__str__() + ', Y = ' + self.y.__str__() + ', Z = ' + self.z.__str__()

    def __unicode__(self):
        return self.x.__str__() + ',' + self.y.__str__() + ',' + self.z.__str__()

    @staticmethod
    def sub(v1, v2):
        x = v1.x - v2.x
        y = v1.y - v2.y
        z = v1.z - v2.z

        result = Vector(x, y, z)
        result.round()
        return result

    @staticmethod
    def add(v1, v2):
        x = v1.x + v2.x
        y = v1.y + v2.y
        z = v1.z + v2.z

        result = Vector(x=x, y=y, z=z)
        result.round()

        return result

    @staticmethod
    def mult(v1, number):
        x = v1.x * number
        y = v1.y * number
        z = v1.z * number
        result = Vector(x=x, y=y, z=z)
        result.round()

        return result

    @staticmethod
    def div(v1, number):
        x = v1.x / number
        y = v1.y / number
        z = v1.z / number
        result = Vector(x=x, y=y, z=z)
        result.round()

        return result

    def copy(self):
        return Vector(self.x, self.y, self.z)

    @staticmethod
    def distance(v1, v2):
        dx = (v1.x - v2.x) * (v1.x - v2.x)
        dy = (v1.y - v2.y) * (v1.y - v2.y)
        dz = (v1.z - v2.z) * (v1.z - v2.z)
        return math.sqrt(dx + dy + dz)

    @staticmethod
    def mid_point(v1, v2):
        x = int((v1.x + v2.x) / float(2))
        y = int((v1.y + v2.y) / float(2))
        z = int((v1.z + v2.z) / float(2))
        return Vector(x, y, z)

    def dot_product(self, other):
        x = self.x * other.x
        y = self.y * other.y
        z = self.z * other.z
        result = x + y + z
        return result

    def cross_product(self, other):
        x = self.y * other.z - self.z * other.y
        y = self.z * other.x - self.x * other.z
        z = self.x * other.y - self.y * other.x

        result = Vector(x=x, y=y, z=z)
        result.round()

        return result

    def length(self):
        length = math.sqrt(self.x ** 2 + self.y ** 2 + self.z ** 2)
        return length

    def get_angle(self, other):
        if self.length() == 0 or other.length() == 0:
            return 0
        product = self.dot_product(other)
        cosine = float(product) / (self.length() * other.length())
        if cosine > 1:
            cosine = 1.0
        elif cosine < -1:
            cosine = -1.0
        angle = math.acos(cosine)
        angle = math.degrees(angle)
        return angle

    @staticmethod
    def get_angle2(v1, v2):
        if v1.length() == 0 or v2.length() == 0:
            return 0
        product = v1.dot_product(v2)
        cosine = product / (v1.length() * v2.length())
        if cosine > 1:
            cosine = 1.0
        elif cosine < -1:
            cosine = -1.0
        angle = math.acos(cosine)
        angle = math.degrees(angle)
        return angle

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y and self.z == other.z

    def round(self):
        self.x = round(self.x, round_digits)
        self.y = round(self.y, round_digits)
        self.z = round(self.z, round_digits)

    def set(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def print_self(self):
        return self.__unicode__()

    def get_magnitude(self):
        return math.sqrt(self.x ** 2 + self.y ** 2 + self.z ** 2)

    def get_normalization(self):
        magnitude = self.get_magnitude()
        return Vector(x=float(self.x) / magnitude, y=float(self.y) / magnitude, z=float(self.z) / magnitude)


class Node:
    def __init__(self, id, type, x, y, z, r, parent=None, children=None):
        self.id = id
        self.position = Vector(x=x, y=y, z=z)
        self.radius = r
        self.type = type
        self.parent = parent
        if not children:
            children = []
        self.children = children

        self.order = 0
        self.branching_order = 0
        self.terminal_degree = 0

    def has_branching_child(self):
        if self.children.__len__() == 0:
            return False

        if self.children[0].is_branching():
            return True

        return self.children[0].has_branching_child()

    def is_soma(self):
        return self.id == 1 or not self.parent

    def is_branching(self):
        return len(self.children) > 1 and not self.is_soma()

    def is_tip(self):
        return len(self.children) == 0

    @property
    def distance_to_parent(self):
        # if the current node is not a soma,
        if not self.is_soma():
            # the length = the euclidean distance
            length = Vector.distance(self.position, self.parent.position)
            # if the parent is some, don't consider the radius of the soma
            if self.parent.is_soma():
                # subtract the radius of the soma (because it is not a sphere in reality)
                length -= self.parent.radius

            return length
        return 0

    @property
    def vector_to_parent(self):

        # if self is not the soma,
        if not self.is_soma():
            result = Vector.sub(self.position, self.parent.position)
            return result

        return None

    def get_path_length_to_parent(self, parent):
        # if the input node is a parent of self
        if self.is_child_of(parent):

            # initialize the path length with 0
            path_length = 0

            # set a pointer that refers to this node
            current_node = self

            # While the pointer doesn't refer to the parent
            while not current_node.id == parent.id:
                path_length += current_node.distance_to_parent

                # Move the pointer (current node) to refer to it's parent
                current_node = current_node.parent

            # Return the result
            return path_length

        # otherwise, return None
        return None

    def get_path_to_parent(self, parent, only_branching=True):
        # check whether the input node is a parent of self
        if self.is_child_of(parent):

            path_nodes = []

            # set a pointer that refers to this node
            current_node = self

            # While the pointer doesn't refer to the soma (because the soma doesn't have a parent),
            while True:
                # if only branching nodes are required,
                if only_branching:
                    # if the current node is branching,
                    if current_node.is_branching():
                        # add it to the result list
                        path_nodes.append(current_node)
                # if all nodes are required,
                else:
                    # add the current node to the result list
                    path_nodes.append(current_node)

                # if the pointer has reached the input parent,
                if current_node.id == parent.id:
                    # go out of the loop
                    break

                # Move the pointer (current node) to refer to it's parent
                current_node = current_node.parent

            # reverse the nodes order, so we have Parent -> child
            path_nodes.reverse()

            # Return the result
            return path_nodes

        return None

    def set_order(self, current_order):

        self.order = current_order
        # print 'Id:', self.id, ',', 'Order:', current_order
        if self.id == '1129' or self.id == 1129 or current_order == 983:
            x=0
        current_order += 1

        for child in self.children:
            child.set_order(current_order)

    def set_branching_order___only_branching_nodes(self, current_order):

        # if this node is branching,
        if self.is_branching():
            # Set the order of the current node (self) to the [current_order] value
            self.branching_order = current_order
            # Encrease the [current_order] by 1
            current_order += 1

        # for each child of the current node,
        for child in self.children:
            # Call this function for the current child node passing the [current_order] value
            # which may have been modified
            # This call is a recursive call.
            child.set_branching_order(current_order)

    def set_branching_order(self, current_order):

        # Set the order of the current node (self) to the [current_order] value
        self.branching_order = current_order

        # if this node is branching,
        if not self.is_soma() and self.is_branching():
            # Encrease the [current_order] by 1
            current_order += 1

        # for each child of the current node,
        for child in self.children:
            # Call this function for the current child node passing the [current_order] value
            # which may have been modified
            # This call is a recursive call.
            child.set_branching_order(current_order)

    def is_child_of(self, parent):

        # if the input node is the some,
        if parent.is_soma():
            # it is always a parent to any node!
            return True

        # Otherwise:
        # put a pointer to self as the current node
        current_node = self.parent

        # While the pointer is not the soma,
        while not current_node.is_soma():
            # if the current node is equal to the input node
            if current_node.id == parent.id:
                # return true (the input node is a prent of self)
                return True
            # otherwise, mode the pointer to the parent
            current_node = current_node.parent

        # if we reached the soma, and no matching node to the input node found,
        # return False, because the input node is not a parent to self
        return False


class Neuron:
    def __init__(self, nodes=None):
        self.name = ''
        self.center = None
        self.branches = []
        self.stems = []
        self.tips = []
        self.branching_nodes = []

        if nodes:
            self.nodes = nodes
            self.initialize()
        else:
            self.nodes = []
        self.name = None

    def get_highest_id(self):
        return max([node.id for node in self.nodes])

    def initialize(self):
        self.tips = self.get_tips()
        self.center = self.calculate_center()
        self.branching_nodes = self.get_branching_nodes()
        self.branches = self.produce_branches()
        # self.set_nodes_order()

    def set_nodes_order(self):
        self.soma.order = -1
        for node in self.soma.children:
            node.set_order(0)

    def get_node_by_id(self, id):
        return next((node for node in self.nodes if node.id == id), None)

    def add_node(self, node):
        self.nodes.append(node)

    @property
    def soma(self):
        return [node for node in self.nodes if node.is_soma()][0]

    def get_tips(self):
        return [node for node in self.nodes if node.is_tip()]

    def get_branching_nodes(self):
        return [node for node in self.nodes if node.is_branching()]

    def calculate_center(self):

        # center = Vector(x=0, y=0, z=0)
        # for node in self.nodes:
        #     center.__add__(node.position)
        # center.__div__(self.nodes.__len__())
        center = Vector(self.get_width()/2, self.get_height()/2, self.get_depth()/2)
        return center

    def get_width(self):
        max_x = max(node.position.x for node in self.nodes)
        min_x = min(node.position.x for node in self.nodes)
        width = abs(max_x - min_x)
        return round(width, round_digits)

    def get_height(self):
        max_y = max(node.position.y for node in self.nodes)
        min_y = min(node.position.y for node in self.nodes)
        height = abs(max_y - min_y)
        return round(height, round_digits)

    def get_depth(self):
        max_z = max(node.position.z for node in self.nodes)
        min_z = min(node.position.z for node in self.nodes)
        depth = abs(max_z - min_z)
        return round(depth, round_digits)

    def get_branching_nodes_in_branch(self, branch_root, branching_nodes):

        if branch_root.is_branching() and not branch_root.is_soma():
            branching_nodes.append(branch_root)

        for child in branch_root.children:
            self.get_branching_nodes_in_branch(child, branching_nodes)

        return branching_nodes

    def get_branches_count(self):
        num_branches = sum(b_n.children.__len__() for b_n in self.branching_nodes)

        num_branches = 0
        for b_n in self.branching_nodes:
            num_branches += b_n.children.__len__()

        return num_branches

    def get_length(self):
        lengths = [node.distance_to_parent for node in self.nodes if not node.is_soma()]
        statistics = calculate_statistics(lengths)

        return statistics

    def produce_branches(self):
        branches = []
        for b_node in self.branching_nodes:
            parent = b_node
            for child in b_node.children:
                while not child.is_tip() and not child.is_branching():
                    child = child.children[0]
                branch = Branch(parent=parent, child=child)
                branches.append(branch)

        return branches

    def get_branch_length(self):
        lengths = [branch.get_length() for branch in self.branches]
        statistics = calculate_statistics(lengths)

        return statistics

    def get_branches_of(self, branch_node):

        if not branch_node.is_branching():
            return None

        branches = []
        for branch in self.branches:
            if branch.parent.id == branch_node.id:
                branches.append(branch)
        return branches

    def get_branches_for_parent(self, parent):
        return [branch for branch in self.branches if branch.parent == parent]

    def contains(self, query_node):
        return [node for node in self.nodes if node.id == query_node.id].__len__() > 0

class Branch:
    def __init__(self, parent, child):
        self.parent = parent
        self.child = child

    def get_euclidean_distance(self):
        return Vector.distance(self.parent.position, self.child.position)

    def get_length(self):
        return self.child.get_path_length_to_parent(self.parent)

    def get_vector(self):
        result = Vector.sub(self.child.position, self.parent.position)
        return result

    @property
    def is_terminal(self):
        return self.child.is_tip()
