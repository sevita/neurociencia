#!/usr/bin/env python
# -*- coding: utf-8 -*-
#help: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
#1958-08-09 primera billboard

from corpus import generarCorpusDeDatos

if __name__ == "__main__":
    #definimos los diccionarios
    rankingBillboard           = {} #hot 100
    cancionesPorAnio           = {} #hot 100
    generos                    = ["pop","rock","country","r-b-hip-hop","rap","dance-electronic","latin"]
    rankingGeneros             = [{},{},{},{},{},{},{}]
    cancionesPorAnioGenero     = [{},{},{},{},{},{},{}]

    #generarCorpusDeDatos(rankingBillboard, cancionesPorAnio, generos, rankingGeneros, cancionesPorAnioGenero)