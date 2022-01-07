import networkx as nx
import numpy as np

def nakljucni_MIS(G, P):
    I = []            #Nastajajoca neodvisna mnozica
    V = list(G.nodes)
    for i in V:        # V tej mnozici izberemo vozlisca, ki jih dodamo neodvisni mnozici. P je permutacija naravnih stevil do vkljucno len(V). Vozlisce dodamo I, ce ima najmanjso vrednost med sosedi.,tako tudi preprecimo ponavljanje vozlisc v mnozici.
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
    V1 = list(dict.fromkeys(V1)) # V1 je mnozica, ki jo bomo odstranili iz grafa in je sestavljena iz vozlisc iz I, ter njihovih sosedov
    if I == []:
        return []
    else:
        G1 = G.copy()
        G1.remove_nodes_from(V1)
        return list(I + nakljucni_MIS(G1, P)) #Algoritem ponovimo za nov graf G, ki je zmanjsan za mnozico V1

G = nx.hypercube_graph(6)
H = nx.convert_node_labels_to_integers(G)
l = len(H.nodes)
B = []
for i in range(100):
    P = list(np.random.permutation(l))
    B.append(nakljucni_MIS(H, P))

print(max([len(i) for i in B]))

C = []
from collections import Counter

for i in B:
    print(Counter(i))
