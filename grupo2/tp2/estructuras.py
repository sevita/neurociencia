

def crearCancion (nombreCancion, artista, fechaIngreso, letra, fechas, posiciones, id_cancion, patricia):
	cancion = {}
	cancion['id'] = id_cancion
	cancion['nombre'] = nombreCancion
	cancion['artista'] = artista
	cancion['fechaIngreso'] = fechaIngreso
	cancion['letra'] = letra
	cancion['fechas'] = [fechas]
	cancion['posiciones'] = [posiciones]

	indicePatricia = nombreCancion + artista
	patricia[indicePatricia] = id_cancion

	return cancion
