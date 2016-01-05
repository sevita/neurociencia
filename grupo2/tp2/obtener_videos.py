import nltk
import urllib3
from multiprocessing import *
from functools import partial





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