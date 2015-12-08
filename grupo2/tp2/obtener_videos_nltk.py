#!/usr/bin/env python
# -*- coding: utf-8 -*-
#help: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
#1958-08-09 primera billboard

import nltk
import urllib3
from datetime import *
from patricia import *
from estructuras import *
from bs4 import BeautifulSoup

bd = {}
cancionesPorAnio = {}

contadorBien = 0
contadorMal = 0

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
    
    return normalizarNombre(nombre)

def normalizarNombre(nombre): 
    caracteresAEliminar = ",!@#$'?/%\\&"
    for caracter in caracteresAEliminar:
        nombre = nombre.replace(caracter,"")
    
    nombre = nombre.replace("  "," ")
    nombre = nombre.lower()
    nombre = nombre.replace(" ", "-")

    return nombre

def obtenerLetra(nombreCancion, nombreArtista): #falta sacar los [] que aparecen en algunas canciones
    cancion = normalizarNombre(nombreCancion)
    artista = normalizarNombreArtista(nombreArtista)

    url = 'http://www.metrolyrics.com/' + cancion + '-lyrics-' + artista + '.html'
    global contadorMal
    global contadorBien

    try:
        letra = ''
        html = http.request('GET', url, preload_content=False).read()
        soup = BeautifulSoup(html, 'html.parser')
        soup = soup.find(id="lyrics-body-text") #obtengo la letra
        for verso in soup.findAll('p'):
            letra = letra + verso.get_text() + ' ' #obtengo los versos
        contadorBien = contadorBien + 1
        return letra.replace("\n", " ").rstrip() #saco los enter's y el último espacio en blanco
        
    except:
        print 'Fallo la URL del Artista: ' + nombreArtista + ' Cancion: ' + nombreCancion + '\n'
        contadorMal = contadorMal + 1

def actualizarLetraMetrolyrics(): 
    nombreCancion = raw_input('Ingrese el nombre de la cancion: ')
    nombreArtista = raw_input('Ingrese el nombre del artista: ')
    url = raw_input('Ingrese la URL de Metrolyrics:')

    clave = normalizarNombre(nombreCancion)+normalizarNombreArtista(nombreArtista)

    letra = ''
    html = http.request('GET', url, preload_content=False).read()
    soup = BeautifulSoup(html, 'html.parser')
    soup = soup.find(id="lyrics-body-text") #obtengo la letra
    for verso in soup.findAll('p'):
        letra = letra + verso.get_text() + ' ' #obtengo los versos
    bd[clave]['letra'] = letra.replace("\n", " ").rstrip() #saco los enter's y el último espacio en blanco
   
def obtenerNombresYoutube(url): #devuelve un arreglo con todas los nombres de los videos de un playlist
    html = http.request('GET', url, preload_content=False).read()
    soup = BeautifulSoup(html, 'html.parser')

    return ",".join([elem.get_text().strip() for elem in soup.findAll("h4", class_= "yt-ui-ellipsis yt-ui-ellipsis-2")])

def obtenerRankingBillboard(fecha): 
    url = 'http://www.billboard.com/charts/hot-100/' + fecha
    html = http.request('GET', url, preload_content=False).read()
    soup = BeautifulSoup(html, 'html.parser')

    cancionesDelRanking = soup.findAll("article", class_= "chart-row")

    if cancionesDelRanking == []:
            print "fallo " + fecha

    anio = fecha[:4] #obtengo el año de la fecha
    if anio not in cancionesPorAnio: #creo un arreglo en donde se van a guardas las canciones que sonaron un año determinado
        cancionesPorAnio[anio] = []

    print anio
    for elem in cancionesDelRanking:
        nombreCancion = elem.find("h2").get_text().strip()
        nombreArtista = elem.find("h3").get_text().strip()
        posicion = elem.find("span", class_= "this-week").get_text().strip()
        clave = normalizarNombre(nombreCancion)+normalizarNombreArtista(nombreArtista)

        if clave not in bd:
            crearCancion (clave, nombreCancion, nombreArtista, fecha, obtenerLetra(nombreCancion, nombreArtista), fecha, posicion, bd) 
            cancionesPorAnio[anio].append(clave)        
        else:
            bd[clave]['fechas'].append(fecha)
            bd[clave]['posiciones'].append(posicion)

def descargarRankingBillboard():
    fecha = date(1958,8,9) #primer chart Billboard

    while fecha < date.today():
        obtenerRankingBillboard(fecha.strftime("%Y-%m-%d"))
        fecha = fecha + timedelta(days=7)   

if __name__ == "__main__":
    http = urllib3.PoolManager()
    
    #print obtenerNombresYoutube('https://www.youtube.com/watch?v=vLv59iiCkZA&list=PLFgquLnL59amyKLSulnqkHkLf-GZRVmtN&index=199')
    
    #print normalizarNombreArtista("Elvis Presley With The Jordanaires")
    #print obtenerLetra(pepe,'justin bieber')

    print bd
    #obtenerRankingBillboard('2015-11-21')

    descargarRankingBillboard()
    print bd
    print len(bd)

   # global contadorMal
   # global contadorBien
    print contadorBien
    print contadorMal