import nltk
import urllib3
from multiprocessing import *
from functools import partial
from datetime import *




def obtenerLetraDeCanciones():
    pool = Pool(processes=8)
    lista = [1,2,3,4,5,6,7,8,9,10]
    g = partial(sumaConInt, b=8)

    datos = pool.map(g, lista)

    print datos

def sumaConInt(a, b):
    return supersuma(a,b)

def supersuma(a,b):
    return b-a

if __name__ == "__main__":
    obtenerLetraDeCanciones()
    lista = [[],[2,3],[4]]
    print lista
    print lista[0]
    lista[0].append(3)
    for idGenero in range(len(lista)):
        print idGenero
    fecha = date.today() 
    print fecha
    fecha = fecha.strftime("%Y-%m-%d")
    print fecha + "hola"
    hola = "/charts/pop-songs/2015-12-05"
    pop = "pop-songs/"
    hola = hola.replace("/charts/"+ pop ,"")
    print hola