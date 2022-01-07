import networkx as nx

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
        return 
    else:
        G.remove_nodes_from(V1)
        return list(I + nakljucni_MIS(G, P)) #Algoritem ponovimo za nov graf G, ki je zmanjsan za mnozico V1
