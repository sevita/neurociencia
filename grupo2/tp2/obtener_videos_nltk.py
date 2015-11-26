#help: http://www.crummy.com/software/BeautifulSoup/bs4/doc/

import nltk
import urllib3
from patricia import *
from estructuras import *
from bs4 import BeautifulSoup

bd = []
T = trie() #pensar si con un dicc que tenga como clave la clave del trie, no alcanza

def normalizarNombre(nombre): #falta eliminar lo ft.
    nombre = nombre.rstrip("Featuring") #esto no anda
    caracteresAEliminar = ",!@#$'?/%\\&"
    for i in range(0,len(caracteresAEliminar)):
        nombre = nombre.replace(caracteresAEliminar[i],"")
    
    nombre = nombre.replace("  "," ")
    nombre = nombre.lower()
    nombre = nombre.replace(" ", "-")

    return nombre

def obtenerLetra(nombreCancion, nombreArtista):
    cancion = normalizarNombre(nombreCancion)
    artista = normalizarNombre(nombreArtista)

    url = 'http://www.metrolyrics.com/' + cancion + '-lyrics-' + artista + '.html'
    try:
        html = http.request('GET', url, preload_content=False).read()
        soup = BeautifulSoup(html, 'html.parser')
        return soup.find(id="lyrics-body-text").get_text()
    except:
        print 'ERROR Artista: ' + nombreArtista + ' Cancion: ' + nombreCancion

def obtenerNombresYoutube(url): #devuelve un arreglo con todas los nombres de los videos de un playlist
    html = http.request('GET', url, preload_content=False).read()
    soup = BeautifulSoup(html, 'html.parser')

    return ",".join([elem.get_text().strip() for elem in soup.findAll("h4", class_= "yt-ui-ellipsis yt-ui-ellipsis-2")])

def obtenerRankingBillboard(fecha): 
    url = 'http://www.billboard.com/charts/hot-100/' + fecha
    html = http.request('GET', url, preload_content=False).read()
    soup = BeautifulSoup(html, 'html.parser')

    cancionesDelRanking = soup.findAll("article", class_= "chart-row")
    
    for elem in cancionesDelRanking:
        nombreCancion = elem.find("h2").get_text().strip()
        nombreArtista = elem.find("h3").get_text().strip()
        posicion = elem.find("span", class_= "this-week").get_text().strip()

        if "row-new" in elem.get('class'):
           cancion = crearCancion (normalizarNombre(nombreCancion), normalizarNombre(nombreArtista), fecha, 'letra de la cancion', fecha, posicion, len(bd), T) 
           bd.append(cancion)

if __name__ == "__main__":
    http = urllib3.PoolManager()
    
    #print obtenerNombresYoutube('https://www.youtube.com/watch?v=vLv59iiCkZA&list=PLFgquLnL59amyKLSulnqkHkLf-GZRVmtN&index=199')
    pepe = 'what do you\ MeDan?'
    print normalizarNombre(pepe)
    #print obtenerLetra(pepe,'justin bieber')
    print pepe

    print obtenerRankingBillboard('2015-11-21')
    print T
