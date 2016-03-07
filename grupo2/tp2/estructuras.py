#!/usr/bin/env python
# -*- coding: utf-8 -*-

def crearCancionBillboard (bd, clave, nombreCancion, artista, posicion): #primera parte
	cancion = {}
	cancion['nombre'] = nombreCancion
	cancion['artista'] = artista
	cancion['letra'] = "none"
	cancion['posiciones'] = posicion #posicion en la que aparece en el ranking

	bd[clave] = cancion

def crearCancion (bd, clave, nombreCancion, artista, fechaIngreso, posiciones):
	cancion = {}
	cancion['nombre'] = nombreCancion
	cancion['artista'] = artista
	cancion['fechaIngreso'] = fechaIngreso
	cancion['letra'] = "none"
	cancion['genero'] = "none"
	cancion['fechas'] = [fechaIngreso] #fechas en las que aparece en el ranking
	cancion['posiciones'] = [posiciones] #posiciones en las que aparece en el ranking

	bd[clave] = cancion

def actualizarCancion(bd, clave, fecha, posicion):
	bd[clave]['fechas'].append(fecha)
	bd[clave]['posiciones'].append(posicion)

def obtenerNombreYArtista(idCancion, bd): #primera parte
    return (bd[idCancion]['nombre'], bd[idCancion]['artista'])

def faltaLetra(idCancion, bd):
    return bd[idCancion]['letra'] == 'none'

def agregarLetra ((idCancion, letra), bd): #primera parte
    if idCancion != 0:
        bd[idCancion]['letra'] = letra

def agregarGenero(genero, idCancion, bd):
	bd[idCancion]['genero'] = genero

def pasarLetra(idCancion, bdBillboard, bdGenero):
	bdGenero[idCancion]['letra'] = bdBillboard[idCancion]['letra']