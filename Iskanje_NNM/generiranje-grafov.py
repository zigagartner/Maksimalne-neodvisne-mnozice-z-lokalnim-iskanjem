from typing import Dict
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import json 


def erdos_reyni(n,p,m):
    dict = {}
    for i in range(m):
        G = nx.erdos_renyi_graph(n,p)
        G_slovar = nx.to_dict_of_lists(G)
        dict[i] = G_slovar
    with open('generirani_grafi.json','w') as js:
        json.dump(dict,js)

   

        

        





erdos_reyni(10,0.4,5)


#nx.draw(G, with_labels=True)
#plt.show()

#for i in range(10):
#    dict = {}
#    vrednosti = 
#    kljuci = list(range(10))
#    G = nx.erdos_renyi_graph(5,0.5)
#    G_slovar = nx.to_dict_of_lists(G)
#
#    dict = dict.fromkeys() G_slovar
#    print(dict)
#


    
