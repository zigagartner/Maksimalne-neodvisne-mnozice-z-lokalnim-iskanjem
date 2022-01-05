import networkx as nx

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


