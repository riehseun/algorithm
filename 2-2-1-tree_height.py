import sys
import threading
from collections import deque


def compute(n, parents):
    """
    Inverts array representation of tree into dictionary representation
    of tree. Then, computes the height of the tree

    Args:
    n -- number of nodes in the tree
    parents -- array representation of tree

    Returns:
    The height of tree
    """

    tree = {}
    root = -1

    for i in range(len(parents)):
        tree[i] = []

    for i in range(len(parents)):
        if parents[i] == -1:
            root = i
        else:
            tree[parents[i]].append(i)

    # Compute height using BFS
    data = bfs(tree, root)
    nodes = data[0]
    last_item = data[1]
    return compute_height_from_bfs(nodes, root, last_item, [0]) + 1

    # Compute height by constructing subtrees
    return compute_height(tree, root)


def compute_height(tree, root):
    """
    Computes the height of the tree

    Args:
    tree -- dictionary representation of tree
    root -- root node of tree

    Returns:
    The height of tree
    """

    # If empty tree
    if len(tree) == 0:
        return 1

    # Root has no children
    if len(tree[root]) == 0:
        return 1

    child_heights = []

    # Traverse all children of the root node
    for node in tree[root]:
        child_tree = find_subtree(tree, node, {})
        child_heights.append(compute_height(child_tree, node))

    # print(child_heights)
    return 1 + max(child_heights)


def find_subtree(tree, root, subtree):
    """
    Computes the subtree (with given root) of the tree

    Args:
    tree -- dictionary representation of tree
    subtree - dictionary representation of subtree (to be filled)
    root -- root node of subtree

    Returns:
    Dictionary representation of subtree
    """

    for key, val in tree.items():
        if key == root and key not in subtree:
            subtree[key] = val
            for node in val:
                find_subtree(tree, node, subtree)

    return subtree


def bfs(tree, root):
    """
    Performs breath first search on tree

    Args:
    tree -- dictionary representation of tree
    root -- root node of tree

    Returns:
    Result of the BFS and the last node of the tree
    """

    if len(tree) == 0:
        return

    # This will be the ouput of the breath-first search
    nodes = {}
    last_item = -1

    queue = deque()
    v = {}
    v[root] = tree[root]
    queue.append(v)
    while len(queue) > 0:
        node = queue.popleft()
        for key, val in node.items():
            nodes[key] = val

            for child in val:
                v = {}
                v[child] = tree[child]
                queue.append(v)
                last_item = child

        # Stores the relationship such that child is the key and parent
        # is the value. This is for easy traversal to calculate the
        # height of the tree. The root of the tree will be excluded
        # since it does not have a parent

        # for item in node[next(iter(node))]:
        #     nodes[item] = next(iter(node))
        # nodes[next(iter(node))] = node[next(iter(node))]

    return (nodes, last_item)


def compute_height_from_bfs(nodes, root, child, height):
    """
    Compute height of the tree from the result of BFS

    Args:
    nodes -- Result of the BFS
    child -- node to start searching to compute the height
    height -- keeping track of height of the tree while searching

    Returns:
    The height of the tree
    """

    # print(nodes)
    # print(child)
    # print(root)

    if child == root:
        return height[0]

    for key, val in nodes.items():
        for item in val:
            if child == item:
                height[0] += 1
                return compute_height_from_bfs(nodes, root, key, height)

    # if child not in nodes:
    #     return height[0]

    # for key, val in nodes.items():
    #     if key == child:
    #         height[0] += 1
    #         return compute_height_from_bfg(nodes, val, height)


# print(compute(5, [4,-1,4,1,1]))
# print(compute(5, [-1,0,4,0,3]))
# print(compute(10, [9,7,5,5,2,9,9,9,2,-1]))


def main():
    # print(compute(5, [4,-1,4,1,1]))
    # print(compute(5, [-1,0,4,0,3]))
    # print(compute(10, [9,7,5,5,2,9,9,9,2,-1]))
    n = int(input())
    parents = list(map(int, input().split()))
    print(compute(n, parents))


# In Python, the default limit on recursion depth is rather low,
# so raise it here for this problem. Note that to take advantage
# of bigger stack, we have to launch the computation in a new thread.
sys.setrecursionlimit(10**7)  # max depth of recursion
threading.stack_size(2**27)   # new thread will get stack of such size
threading.Thread(target=main).start()