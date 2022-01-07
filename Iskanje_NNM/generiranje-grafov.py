from typing import Dict
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import json 



#N je seznam različnih velikosti grafa
#m je število grafov vsake vrste, ki jih bo generiralo
def erdos_renyi_N(N,p,m,ime_datoteke_json):
    db = {}
    for n in N:
        G = nx.erdos_renyi_graph(n,p)
        G_slovar = nx.to_dict_of_lists(G)
        db[n] = G_slovar        
    zapisi_v_json(ime_datoteke_json,db)
    return db

#P je seznam različnih verjetnosti
def erdos_renyi_P(n,P,m,ime_datoteke_json):
    db = {}
    for p in P:
        G = nx.erdos_renyi_graph(n,p)
        G_slovar = nx.to_dict_of_lists(G)
        db[p] = G_slovar        
    zapisi_v_json(ime_datoteke_json,db)
    return db


def zapisi_v_json(datoteka,db):
    with open(datoteka +'.json','w') as js:
        json.dump(db, js)


print(erdos_renyi_N([5,10],0.5,5,'erdos-grafi'))


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

