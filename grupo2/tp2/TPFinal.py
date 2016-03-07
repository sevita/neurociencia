#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pickle

from corpus import *
#from corpus import generarCorpusDeDatos
from riquezaLexica import *

if __name__ == "__main__":
    #definimos los diccionarios
    rankingBillboard           = {} #hot 100
    generos                    = ["pop","rock","country","r-b-hip-hop","rap","dance-electronic","latin"]
    rankingGeneros             = [{},{},{},{},{},{},{}]
    cancionesPorAnioGenero     = [{},{},{},{},{},{},{}]

    #generarCorpusDeDatos(rankingBillboard, generos, rankingGeneros, cancionesPorAnioGenero) dejar comentado para no borrar la bd

    file_Name = "datos/bdConLetra2.txt"
    fileObject = open(file_Name,'r') 
    bd = pickle.load(fileObject)
    fileObject.close()
    
    #print bd

    for can in bd.keys():
        if bd[can]["genero"] != []:
            print bd[can]["genero"]
    

    #hola = 0
    #for can in bd.keys():
    #    bd[can]["letra"]= bd[can]["letra"].replace("\n", " ")
    #    print bd[can]["letra"]
    #    hola = hola + 1
    #print hola
    #print bd
    #guardamos los datos parciales
    #file_Name = "datos/bdRankingHistoricoBillboard.txt"
    #fileObject = open(file_Name,'wb') 
    #pickle.dump(bd,fileObject) 
    #fileObject.close()

def funcionAuxiliarParaCruzarBases():
    file_Name = "datos/bdGeneros.txt"
    fileObject = open(file_Name,'r') 
    bdGeneros = pickle.load(fileObject)
    fileObject.close()

    file_Name = "datos/bdConLetra2.txt"
    fileObject = open(file_Name,'r') 
    bdBillboard = pickle.load(fileObject)
    fileObject.close()

    elem = 0

    for idGenero in range(len(generos)):
        for clave in bdGeneros[idGenero].keys():
            if clave in bdBillboard:
                #colocamos el nombre del genero en la bd de billboard
                agregarGenero(generos[idGenero], clave, bdBillboard)
                #colocamos la letra del tema en la bd del genero
                pasarLetra(clave, bdBillboard, bdGeneros[idGenero])
                elem = elem + 1

    print elem
    #guardamos los datos parciales
    file_Name = "datos/bdGeneros.txt"
    fileObject = open(file_Name,'wb') 
    pickle.dump(bdGeneros,fileObject) 
    fileObject.close()

    #guardamos los datos parciales
    file_Name = "datos/bdConLetra2.txt"
    fileObject = open(file_Name,'wb') 
    pickle.dump(bdBillboard,fileObject) 
    fileObject.close()

def descargarRankingBillboard(bd, cancionesPorAnio):
    fecha = date(1958,8,9) #primer chart Billboard
    
    while fecha < date.today():
        #actualizamos la base de datos con las canciones del chart de esa semana
        try:
            #obtenemos el html de la pagina
            url = 'http://www.billboard.com/charts/hot-100/' + fecha.strftime("%Y-%m-%d")
            html = http.request('GET', url, preload_content=False).read()
            soup = BeautifulSoup(html, 'html.parser')

            #obtenemos los datos de las canciones del ranking y las guardamos en la bd
            cancionesDelRanking = soup.findAll("article", class_= "chart-row")
            cargarChart(fecha, bd, cancionesPorAnio, cancionesDelRanking)
            
        except:
            print "fallo " + fecha.strftime("%Y-%m-%d")
            print >> sys.stderr, "fallo " + fecha.strftime("%Y-%m-%d")

        fecha = fecha + timedelta(days=7)   

        #guardamos los datos parciales
        file_Name = "datos/bdConLetra3.txt"
        fileObject = open(file_Name,'wb') 
        pickle.dump(bd,fileObject) 
        fileObject.close()
        
        file_Name = "datos/cancionesPorAnio.txt"
        fileObject = open(file_Name,'wb') 
        pickle.dump(cancionesPorAnio,fileObject) 
        fileObject.close()