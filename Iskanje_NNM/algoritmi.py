import networkx as nx
import random
G = nx.hypercube_graph(6)

def MIS(G):
    H = nx.convert_node_labels_to_integers(G)
    V = list(H.nodes)
    V1= V
    I = []
    while V1 != []:
        for i in V1:
            if i == min(V1):
                I.append(i)
                for j in V1:
                    if j in H.neighbors(i):
                        V1.remove(j)
                V1.remove(i)
            else:
                pass
    return I



def nakljucni_MIS(G):
    H = nx.convert_node_labels_to_integers(G)
    I = []
    P = []
    V = list(H.nodes)
    for i in V:
        P.append(random.uniform(0, 1))
    for i in V:
        A = []
        A.append(P[i])
        for j in H.neighbors(i):
            A.append(P[j])
        if P[i] == min(A):
            I.append(i)
    N = []
    for i in I:
        N += list(H.neighbors(i))
    V1 = I + N
    V1 = list(dict.fromkeys(V1))
    H.remove_nodes_from(V1)
    if V1 == []:
        return I
    else:
        H.remove_nodes_from(V1)
        return list(I + nakljucni_MIS(H))

