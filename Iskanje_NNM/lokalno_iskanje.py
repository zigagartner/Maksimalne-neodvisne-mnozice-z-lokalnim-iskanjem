import networkx as nx

def tightness(graf, mnozica, v): #Dolocimo "tightness" vozlisca v, v mnozici X, tj. za vsakega soseda vozlisca v, v mnozici graf\X, tightness(v) povecamo za 1
    t = 0
    for w in graf.neighbors(v):
        if w in mnozica:
            t += 1
        else:
            pass
    return t

def lokalno_iskanje(G, I): #Parametra graf v networkx formatu, neodvisna množica I (gre za Python list)
    V = list(G.nodes)
    for v in I:
        L = [] #Gradimo mnozice potencialnih kandidatov za dodajanje v neodvisno mnozico
        for w in G.neighbors(v):
            if G.neighbors(v) != []:
                if tightness(G, I, w) == 1:
                    L.append(w)
                else:
                    pass
            else:
                pass
        if len(L) >= 2:
            for v1 in L:
                for w1 in L:
                    if w1 not in G.neighbors(v1):
                        I.remove(v)
                        I_lokalno = I + [v1, w1]
                        return lokalno_iskanje(G, I_lokalno)
        else:
            return I 




