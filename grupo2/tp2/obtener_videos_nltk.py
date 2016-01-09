#!/usr/bin/env python
# -*- coding: utf-8 -*-
#help: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
#1958-08-09 primera billboard

import nltk
import sys
from urllib3 import *
import pickle
from datetime import *
from PyLyrics import *
from estructuras import *
from bs4 import BeautifulSoup
from pyechonest import *
from multiprocessing import *
from functools import partial
    
config.ECHO_NEST_API_KEY="RC8OZFTSKR6SJWGHF"

###################################################################################################
#####                                Normalizamos los nombres                                 #####
###################################################################################################
def normalizarNombreArtista(nombre):
    borrar = nombre.find(" Featuring ")
    if borrar != -1:
        nombre = nombre[:borrar] #borra todo lo que le sigue a Featuring
    borrar = nombre.find(" featuring ")
    if borrar != -1:
        nombre = nombre[:borrar] #borra todo lo que le sigue a Featuring
    
    borrar = nombre.find(" & ")
    if borrar != -1:
        nombre = nombre[:borrar] 
    
    borrar = nombre.find(" And ")
    if borrar != -1:
        nombre = nombre[:borrar] 
    borrar = nombre.find(" and ")
    if borrar != -1:
        nombre = nombre[:borrar] 

    borrar = nombre.find(" With ")
    if borrar != -1:
        nombre = nombre[:borrar] 
    borrar = nombre.find(" with ")
    if borrar != -1:
        nombre = nombre[:borrar] 
    
    nombre = nombre.replace('$', 's')

    return normalizarNombre(nombre)

def normalizarNombre(nombre): 
    caracteresAEliminar = ".,!@#$'?/%\\&"
    for caracter in caracteresAEliminar:
        nombre = nombre.replace(caracter,"")
    
    nombre = nombre.replace("  "," ")
    nombre = nombre.lower()
    nombre = nombre.replace(" ", "-")

    return nombre

###################################################################################################
#####                           Obtenemos las canciones de Billboard                          #####
###################################################################################################
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
            print "fallo " + fecha
            print >> sys.stderr, "fallo " + fecha

        fecha = fecha + timedelta(days=7)   

        #guardamos los datos parciales
        file_Name = "datos/bd.txt"
        fileObject = open(file_Name,'wb') 
        pickle.dump(bd,fileObject) 
        fileObject.close()
        
        #guardamos los datos parciales
        file_Name = "datos/cancionesPorAnio.txt"
        fileObject = open(file_Name,'wb') 
        pickle.dump(cancionesPorAnio,fileObject) 
        fileObject.close()

def cargarChart(fecha, bd, cancionesPorAnio, cancionesDelRanking):
    if cancionesDelRanking == []:
        print "fallo " + fecha
        print >> sys.stderr,"fallo " + fecha
    else:
        anio = fecha[:4] #obtenemos el año de la fecha
        if anio not in cancionesPorAnio: #creamos un arreglo en donde se van a guardas las canciones que sonaron un año determinado
            cancionesPorAnio[anio] = []

        for elem in cancionesDelRanking:
            #obtenemos los datos
            nombreCancion = elem.find("h2").get_text().strip()
            nombreArtista = elem.find("h3").get_text().strip()
            posicion = elem.find("span", class_= "this-week").get_text().strip()
            clave = normalizarNombre(nombreCancion)+normalizarNombreArtista(nombreArtista)

            #creamos la cancion si es que no existe. Caso contrario agregamos la fecha de 
            #este chart y la posicion en la que aparecio
            if clave not in bd:
                crearCancion (bd, clave, nombreCancion, nombreArtista, fecha, posicion) 
                cancionesPorAnio[anio].append(clave)        
            else:
                actualizarCancion(bd, clave, fecha, posicion)

###################################################################################################
#####                          Obtenemos las letras de las canciones                          #####
###################################################################################################
def obtenerLetraDeCancionesGeneros(bd, generos):
    for idGenero in range(len(generos)):
        obtenerLetraDeCanciones(bd[idGenero])
        
def obtenerLetraDeCanciones(bd):
    #paralelizamos la obtencion de datos
    pool = Pool(processes=4)

    funcionAux = partial(obtenerLetra, bd=bd)
    datos = pool.map(funcionAux, bd.keys())

    #una vez que tenemos todas las letras, las guardamos en la base de datos
    for letra in datos:
        agregarLetra(letra, bd)

def obtenerLetra(idCancion, bd):
    (nombreCancion, nombreArtista) = obtenerNombreYArtista(idCancion, bd)

    if faltaLetra(idCancion, bd):
        letra = obtenerLetraPyLyrics(nombreCancion, nombreArtista) #trae todas las letras de las canciones

        return (idCancion, letra)
    else:
        return (0, 0)

def obtenerLetraPyLyrics(nombreCancion, nombreArtista): 
    try:
        letra = PyLyrics.getLyrics(nombreArtista,nombreCancion) #obtenemos la leta de PyLyrics  
        letra.replace("\n", " ")
        letra.replace("\n", " ").rstrip()
        print "PyLyrics"
        print >> sys.stderr,"PyLyrics"
        return letra
    except:
        return obtenerLetraMetrolyrics(nombreCancion, nombreArtista)

def obtenerLetraMetrolyrics(nombreCancion, nombreArtista): 
    cancion = normalizarNombre(nombreCancion)
    artista = normalizarNombreArtista(nombreArtista)

    url = 'http://www.metrolyrics.com/' + cancion + '-lyrics-' + artista + '.html'

    try:
        letra = ''
        http = PoolManager(timeout=Timeout(connect=30.0))
        html = http.request('GET', url, preload_content=False).read()
        soup = BeautifulSoup(html, 'html.parser')
        soup = soup.find(id="lyrics-body-text") #obtenemos la letra
        for verso in soup.findAll('p'):
            letra = letra + verso.get_text() + ' ' #obtenemos los versos
        print "Metrolyrics"
        print >> sys.stderr,"Metrolyrics"
        return letra.replace("\n", " ").rstrip() #sacamos los enter's y el último espacio en blanco
        
    except:
        return obtenerLetraLyricsfreak(nombreCancion, nombreArtista)

def obtenerLetraLyricsfreak(nombreCancion, nombreArtista): 
    artista = normalizarNombreArtista(nombreArtista)

    url = 'http://www.lyricsfreak.com/l/' + artista + '/' #buscamos el artista
    try:
        http = PoolManager(timeout=Timeout(connect=30.0))

        html = http.request('GET', url, preload_content=False).read()
        soup = BeautifulSoup(html, 'html.parser')
        
        titulo = nombreCancion + " Lyrics"
        soup = soup.find(title=titulo) #buscamos la url de la cancion
        
        url = "http://www.lyricsfreak.com/" + soup["href"] 
        http = PoolManager(timeout=Timeout(connect=30.0))

        html = http.request('GET', url, preload_content=False).read() #buscamos la canción
        soup = BeautifulSoup(html, 'html.parser')
        soup = soup.find(id='content_h')
        
        letra = str(soup) #limpiamos la letra de la cancion
        letra = letra.replace('<br><br>', ' ')
        letra = letra.replace('<br>', ' ')
        letra = letra.replace('</br>', ' ')
        letra = letra.replace('</div>', ' ')
        letra = letra.replace('<div class="dn" id="content_h">', '').rstrip()
        print "Lyricsfreak"
        print >> sys.stderr,"Lyricsfreak"
        
        return letra
        
    except:
        print 'Fallo la URL del Artista: ' + nombreArtista + ' Cancion: ' + nombreCancion + '\n'
        print >> sys.stderr,'Fallo la URL del Artista: ' + nombreArtista + ' Cancion: ' + nombreCancion + '\n'
        return "none"
    
###################################################################################################
#####                          Obtenemos los generos de las canciones                         #####
###################################################################################################
def descargarRankingGeneros(bdGeneros, cancionesPorAnio, generos, bdBillboard):
    for idGenero in range(len(generos)):
        fecha = date(2016,1,9)
        print fecha
        print >> sys.stderr,fecha

        fecha = fecha.strftime("%Y-%m-%d")
        fallo = False

        while not fallo:
            #actualizamos la base de datos con las canciones del chart de esa semana
            try:
                #obtenemos el html de la pagina
                url = 'http://www.billboard.com/charts/' + generos[idGenero] + '-songs/' + fecha
                
                print url
                print >> sys.stderr,url
                http = PoolManager()
                html = http.request('GET', url, preload_content=False).read()
                soup = BeautifulSoup(html, 'html.parser')

                #obtenemos los datos de las canciones del ranking y las guardamos en la bd
                cancionesDelRanking = soup.findAll("article", class_= "chart-row")
                cargarChart(fecha, bdGeneros[idGenero], cancionesPorAnio[idGenero], cancionesDelRanking)
                
                siguienteChart = soup.find(class_="chart-nav-link prev")
                siguienteChart = siguienteChart.get('href')

                fecha = siguienteChart.replace("/charts/" + generos[idGenero] + "-songs/"," ").strip()
            except:
                fallo = True
                print "fallo " + fecha
                print >> sys.stderr,"fallo " + fecha


            #guardamos los datos parciales
            file_Name = "datos/bdGeneros.txt"
            fileObject = open(file_Name,'wb') 
            pickle.dump(bdGeneros,fileObject) 
            fileObject.close()
            
            #guardamos los datos parciales
            file_Name = "datos/cancionesPorAnioGeneros.txt"
            fileObject = open(file_Name,'wb') 
            pickle.dump(cancionesPorAnio,fileObject) 
            fileObject.close()

        cruzarBases(generos[idGenero], bdGeneros[idGenero], bdBillboard)

def cruzarBases(genero, bdGenero, bdBillboard):
    for clave in bdGenero.keys():
        if clave in bdBillboard:
            #colocamos el nombre del genero en la bd de billboard
            agregarGenero(genero, clave, bdBillboard)
            #colocamos la letra del tema en la bd del genero
            pasarLetra(clave, bdBillboard, bdGenero)

if __name__ == "__main__":
    #definimos los diccionarios
    rankingBillboard           = {} #hot 100
    cancionesPorAnio           = {} #hot 100
    generos                    = ["pop","rock","country","r-b-hip-hop","rap","dance-electronic","latin"]
    rankingGeneros             = [{},{},{},{},{},{},{}]
    cancionesPorAnioGenero     = [{},{},{},{},{},{},{}]

    #leo los datos
    file_Name = "datos/bdConLetra2.txt"
    fileObject = open(file_Name,'r')  
    rankingBillboard = pickle.load(fileObject) 
    fileObject.close()

    #leo los datos
    file_Name = "datos/cancionesPorAnio.txt"
    fileObject = open(file_Name,'r')  
    cancionesPorAnio = pickle.load(fileObject) 
    fileObject.close()

    #creamos un diccionario en el cual se guardan todas las canciones que 
    #figuran en el ranking billboard junto a la fecha en la que
    #aparecen y su posicion en dicho ranking
        #descargarRankingBillboard(rankingBillboard, cancionesPorAnio)
    #agregamos las letras de las canciones 
        #obtenerLetraDeCanciones(rankingBillboard)
    #descargamos los generos de las canciones
    descargarRankingGeneros(rankingGeneros, cancionesPorAnioGenero, generos, rankingBillboard)

    #guardamos los datos parciales
    file_Name = "datos/bdGeneros.txt"
    fileObject = open(file_Name,'wb') 
    pickle.dump(rankingGeneros,fileObject) 
    fileObject.close()
    
    #guardamos los datos parciales
    file_Name = "datos/cancionesPorAnioGeneros.txt"
    fileObject = open(file_Name,'wb') 
    pickle.dump(cancionesPorAnioGenero,fileObject) 
    fileObject.close()

    print "agregar letra"
    print >> sys.stderr,"agregar letra"

    #agregamos las letras de las canciones de los generos que falten
    obtenerLetraDeCancionesGeneros(rankingGeneros, generos)

    #guardamos los datos parciales
    file_Name = "datos/bdGeneros.txt"
    fileObject = open(file_Name,'wb') 
    pickle.dump(rankingGeneros,fileObject) 
    fileObject.close()
    
    #guardamos los datos parciales
    file_Name = "datos/cancionesPorAnioGeneros.txt"
    fileObject = open(file_Name,'wb') 
    pickle.dump(cancionesPorAnioGenero,fileObject) 
    fileObject.close()

    file_Name = "datos/bdConLetra3.txt"
    fileObject = open(file_Name,'wb') 
    pickle.dump(cancionesPorAnioGenero,fileObject) 
    fileObject.close()

    print "MIL GRACIAS GASTON!!!!!"
    #leo los datos
    #file_Name = "datos/bdConLetra2.txt"
    #fileObject = open(file_Name,'r')  
    #bd = pickle.load(fileObject) 
    #fileObject.close()
    
    #guardo los datos
    #file_Name = "datos/bdConLetra2.txt"
    #fileObject = open(file_Name,'wb') 
    #pickle.dump(bd,fileObject) 
    #fileObject.close()



 #  def actualizarLetraMetrolyrics(): 
 #   nombreCancion = raw_input('Ingrese el nombre de la cancion: ')
 #   nombreArtista = raw_input('Ingrese el nombre del artista: ')
 #   url = raw_input('Ingrese la URL de Metrolyrics:')

 #  clave = normalizarNombre(nombreCancion)+normalizarNombreArtista(nombreArtista)

 #   letra = ''
 #   html = http.request('GET', url, preload_content=False).read()
 #   soup = BeautifulSoup(html, 'html.parser')
 #   soup = soup.find(id="lyrics-body-text") #obtengo la letra
 #   for verso in soup.findAll('p'):
 #       letra = letra + verso.get_text() + ' ' #obtengo los versos
 #   bd[clave]['letra'] = letra.replace("\n", " ").rstrip() #saco los enter's y el último espacio en blanco
