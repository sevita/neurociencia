import nltk
import urllib3

def obtenerInfoYoutube(url, etiquetaInicio, etiquetaFin):
    html = http.request('GET', url, preload_content=False).read()
    ind = html.find(etiquetaInicio)
    ind = ind + len(etiquetaInicio) #tam de <div class="watch-view-count">
    ind2 = html.find(etiquetaFin,ind)
    return html[ind:ind2]




if __name__ == "__main__":
    http = urllib3.PoolManager()
    url = 'https://www.youtube.com/watch?v=YY33oEDtJv0&list=PLJ5I5YkfRZ_fkL2bRCZpoC1sMbzVIbiRU&index=19'
    view = obtenerInfoYoutube(url,'<div class="watch-view-count">','</div>')
    titulo = obtenerInfoYoutube(url,'<title>','- YouTube</title>')

    print view
    print titulo