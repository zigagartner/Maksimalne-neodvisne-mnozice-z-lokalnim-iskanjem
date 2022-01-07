from itertools import count
import networkx as nx
import numpy as np
from collections import Counter

def nakljucni_MIS(G, P):
    I = []            #Nastajajoca neodvisna mnozica
    V = list(G.nodes)
    for i in V:        # V tej mnozici izberemo vozlisca, ki jih dodamo neodvisni mnozici. P je permutacija naravnih stevil do vkljucno len(V). Vozlisce dodamo I, ce ima najmanjso vrednost med sosedi. Tako tudi preprecimo ponavljanje vozlisc v mnozici.
        A = []      
        A.append(P[i])
        if list(G.neighbors(i)) != []:
            for j in list(G.neighbors(i)):
                A.append(P[j])
        if P[i] == min(A):
            I.append(i)
    N = [] 
    for i in I:
        N += G.neighbors(i)         #seznam sosedov vseh vozlišč iz I
    V1 = I + N                      # V1 je mnozica, ki jo bomo odstranili iz grafa in je sestavljena iz vozlisc iz I, ter njihovih sosedov
    #V1 = list(dict.fromkeys(V1))   to je nepotrebno ker je isto kot zgoraj
    if I == []:
        return []
    else:
        G1 = G.copy()
        G1.remove_nodes_from(V1)               #Odstranimo vozlišča V1 iz grafa G1, ker to niso kandidati za v I
        return list(I + nakljucni_MIS(G1, P)) #Algoritem ponovimo za nov graf G1, ki je zmanjsan za mnozico V1




#Preverimo, da se vozlišča v posamezni neodvisni množici pojavijo res samo enkrat
def stetje(B):  #B je seznam maksimalnih neodvisnih množic, ki ga vrne algoritem
    i = 0
    for S in B:
        stetje = list(Counter(S).values())
        if len(stetje) == stetje.count(1):
            i+=1
    if i == len(B):
        print("Super, nič se ni ponovilo!")
   


#-----------------------------------------------------------TESTIRANJE-----------------------------------------------------

G = nx.hypercube_graph(6)
H = nx.convert_node_labels_to_integers(G)
l = len(H.nodes)
B = []
for i in range(100):
    P = list(np.random.permutation(l))
    B.append(nakljucni_MIS(H, P))   #B je seznam seznamov (maksimalnih neodvisnih množic vsake ponovitve algoritma nakljucni_MIS)
print(f"Največja neodvisna množica dobljena z lokalnim iskanjem ima moč {max([len(i) for i in B])}.")
stetje(B)


