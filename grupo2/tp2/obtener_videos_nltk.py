#!/usr/bin/env python
# -*- coding: utf-8 -*-
#help: http://www.crummy.com/software/BeautifulSoup/bs4/doc/

import nltk
import urllib3
from datetime import *
from patricia import *
from estructuras import *
from bs4 import BeautifulSoup

bd = {}

def normalizarNombre(nombre): 
    borrar = nombre.find(" Featuring")
    if borrar != -1:
        nombre = nombre[:borrar] #borra todo lo que le sigue a Featuring

    caracteresAEliminar = ",!@#$'?/%\\&"
    for caracter in caracteresAEliminar:
        nombre = nombre.replace(caracter,"")
    
    nombre = nombre.replace("  "," ")
    nombre = nombre.lower()
    nombre = nombre.replace(" ", "-")

    return nombre

def obtenerLetra(nombreCancion, nombreArtista): #falta sacar los [] que aparecen en algunas canciones
    cancion = normalizarNombre(nombreCancion)
    artista = normalizarNombre(nombreArtista)

    url = 'http://www.metrolyrics.com/' + cancion + '-lyrics-' + artista + '.html'
    while True:
        try:
            letra = ''
            html = http.request('GET', url, preload_content=False).read()
            soup = BeautifulSoup(html, 'html.parser')
            soup = soup.find(id="lyrics-body-text") #obtengo la letra
            for verso in soup.findAll('p'):
                letra = letra + verso.get_text() + ' ' #obtengo los versos
            return letra.replace("\n", " ").rstrip() #saco los enter's y el último espacio en blanco
        except:
            url = raw_input('Ingrese la URL del Artista: ' + nombreArtista + ' Cancion: ' + nombreCancion + '\n')
            print url

def obtenerNombresYoutube(url): #devuelve un arreglo con todas los nombres de los videos de un playlist
    html = http.request('GET', url, preload_content=False).read()
    soup = BeautifulSoup(html, 'html.parser')

    return ",".join([elem.get_text().strip() for elem in soup.findAll("h4", class_= "yt-ui-ellipsis yt-ui-ellipsis-2")])

def obtenerRankingBillboard(fecha): #hay que habilitar que se actualicen los valores
    url = 'http://www.billboard.com/charts/hot-100/' + fecha
    html = http.request('GET', url, preload_content=False).read()
    soup = BeautifulSoup(html, 'html.parser')

    cancionesDelRanking = soup.findAll("article", class_= "chart-row")
    
    for elem in cancionesDelRanking:
        nombreCancion = elem.find("h2").get_text().strip()
        nombreArtista = elem.find("h3").get_text().strip()
        posicion = elem.find("span", class_= "this-week").get_text().strip()

        if "row-new" in elem.get('class'):
            crearCancion (normalizarNombre(nombreCancion), normalizarNombre(nombreArtista), fecha, obtenerLetra(nombreCancion, nombreArtista), fecha, posicion, bd) 
        #else:
            clave = normalizarNombre(nombreCancion)+normalizarNombre(nombreArtista)
            bd[clave]['fechas'].append(fecha)
            bd[clave]['posiciones'].append(posicion)

def descargarRankingBillboard():
    mydate = date(1943,3, 13)
    print mydate.year
    print mydate + timedelta(days=7)

    fecha = date(1979,12,29)
    while True:
        url = 'http://www.billboard.com/charts/hot-100/' + fecha.strftime("%Y-%m-%d")
        html = http.request('GET', url, preload_content=False).read()
        soup = BeautifulSoup(html, 'html.parser')
        
        if soup.findAll("article", class_= "chart-row") == []:
            print "fallo " + fecha.strftime("%Y-%m-%d")
            break

        fecha = fecha - timedelta(days=7)
        print fecha
    
        
    

if __name__ == "__main__":
    http = urllib3.PoolManager()
    
    #print obtenerNombresYoutube('https://www.youtube.com/watch?v=vLv59iiCkZA&list=PLFgquLnL59amyKLSulnqkHkLf-GZRVmtN&index=199')
    pepe = 'Fetty Wap Featuring Remy Boyz'
    
    print normalizarNombre(pepe)
    #print obtenerLetra(pepe,'justin bieber')
    print pepe

    print bd
    #obtenerRankingBillboard('2015-11-21')

    descargarRankingBillboard()
    print bd
    print len(bd)