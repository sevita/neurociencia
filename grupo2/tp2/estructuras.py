

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

def obtenerNombreYArtista(idCancion, bd):
    return (bd[idCancion]['nombre'], bd[idCancion]['artista'])

def faltaLetra(idCancion, bd):
    return bd[idCancion]['letra'] == 'none'

def agregarLetra ((idCancion, letra), bd):
    if idCancion != 0:
        bd[idCancion]['letra'] = letra