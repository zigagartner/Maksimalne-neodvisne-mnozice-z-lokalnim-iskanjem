from typing import Dict
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import json 

def zapisi_v_json(datoteka,A):
    with open(datoteka +'.json','w') as js:
        js.write(
            '[' +
            ',\n'.join(json.dumps(i) for i in A) +
            ']\n')

# Dano verjetnost in n
def erdos_renyi(n,p,m,ime_datoteke_json):
    A = []
    for i in range(m):
        G = nx.erdos_renyi_graph(n,p)
        G_slovar = nx.to_dict_of_lists(G)
        A += [G_slovar]
    zapisi_v_json(ime_datoteke_json, A)
    return A


erdos_renyi(5,0.5,5,'test')

# Razlicne n

def erdos_renyi_N(N, p, ime_datoteke_json):
    A = []
    for i in N:
        G = nx.erdos_renyi_graph(i,p)
        G_slovar = nx.to_dict_of_lists(G)
        A += [G_slovar]
    zapisi_v_json(ime_datoteke_json, A)
    return A


#Razlicne p

def erdos_renyi_P(n, P, ime_datoteke_json):
    A = []
    for i in P:
        G = nx.erdos_renyi_graph(n,i)
        G_slovar = nx.to_dict_of_lists(G)
        A += [G_slovar]
    zapisi_v_json(ime_datoteke_json, A)
    return A







#ne dela vredu ker na koncu ko spreminjam kljuce iz str v int zafrknem in dodam k vsakem klucu isti slovar (treba zanke prau nastavit s+ce bova rabla)   
#def preberi_json(json_file):
#    with open(json_file+'.json') as file:
#            db_json = json.load(file)
#    output_dict = {}
#    for key, value in db_json.items():
#        output_dict[int(key)] = value
#    koncni = {}
#    for key,value in output_dict.items():
#        for k,v in value.items():
#            koncni[int(k)] = v
#        output_dict[key] = koncni
#    return output_dict

        




#nx.draw(G, with_labels=True)
#plt.show()

