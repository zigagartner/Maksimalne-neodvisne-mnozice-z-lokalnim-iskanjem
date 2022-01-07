import networkx as nx
import numpy as np


def nakljucni_MIS(G, P):
    I = []
    V = list(G.nodes)
    for i in V:
        A = []
        A.append(P[i])
        if list(G.neighbors(i)) != []:
            for j in list(G.neighbors(i)):
                A.append(P[j])
        if P[i] == min(A):
            I.append(i)
    N = []
    for i in I:
        N += G.neighbors(i)
    V1 = I + N
    V1 = list(dict.fromkeys(V1))
    if I == []:
        return 
    else:
        G.remove_nodes_from(V1)
        return list(I + nakljucni_MIS(G, P))

G = nx.hypercube_graph(4)
H = nx.convert_node_labels_to_integers(G)




