

def crearCancion (nombreCancion, artista, fechaIngreso, letra, fechas, posiciones, bd):
	cancion = {}
	cancion['nombre'] = nombreCancion
	cancion['artista'] = artista
	cancion['fechaIngreso'] = fechaIngreso
	cancion['letra'] = letra
	cancion['fechas'] = [fechas]
	cancion['posiciones'] = [posiciones]

	indice = nombreCancion + artista
	bd[indice] = cancion
