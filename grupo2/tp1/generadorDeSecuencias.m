%cantPasesxColor: cantidad de veces que aparecen los colores
%cantColores: cantidad de colores
%entrenamiento: si está en verdadero, se le asigna a la mitad de las pasadas el color de letra blanco
%numExperimento: si es 1, se coloca el fondo negro, si es 2, se coloca el fono random
function [secuencia]=generadorDeSecuencias(cantPasesxColor,cantColores,entrenamiento,numExperimento)

%pongo las palabras de manera pseudoaleatoreas 
palabra=[];
secuencia=[];

for i = 1:cantPasesxColor
	palAux = [];
	for j = 1:cantColores 
		palAux= [palAux; j];
	end
	palAux = palAux(randperm(size(palAux,1)),:);
	if size(palabra) == 0
		palabra = palAux;
	else
		[f,c] = size(palabra);
		if palabra(f,1)==palAux(1,1)
			palAux = circshift(palAux,1); %roto un lugar a la derecha el vector
		end
		palabra = [palabra; palAux];
	end
end

%asigno color de palabra
color=[]; 
for i = 1:cantColores
	numAux=ones(1,cantPasesxColor)*i;
	for j = 1:cantPasesxColor/2
		while true
			pos=randi(cantPasesxColor);
			if numAux(1,pos)==i
				if not(entrenamiento)
					pintar=randi(cantColores);
					while pintar == i
						pintar = randi(cantColores);
					end
				else
					pintar=6;
				end
				numAux(1,pos)=pintar;
				break;
			end
		end
	end
	color=[color;numAux];
end
color

%pinto las palabras y el fondo
indice=ones(1,cantColores);
for i = 1:cantPasesxColor
	for j = 1:cantColores 
		numero=palabra(j+(i-1)*cantColores,1);
		colorLetra=color(numero, indice(1,numero));
		indice(1,numero)=indice(1,numero)+1;
		if numExperimento == 1
			fondo = 5;
        else
            if entrenamiento
                fondo = 5;
            else
                fondo = randi(cantColores);
                [fil,col]=size(secuencia);
                while fondo == colorLetra | (fil~=0 && (fondo==secuencia(fil,3)))
                    fondo = randi(cantColores);
                end
            end
		end
		secuencia=[secuencia; numero colorLetra fondo];
	end
end
%{
%congruentes
secuencia=[]
for i = 1:cantPasesxColor/2
	for j = 1:cantColores 
		if numExperimento == 1
			fondo = 5;
		else
			fondo = randi(cantColores);
			while fondo == j
				fondo = randi(cantColores);
			end
		end
		secuencia = [secuencia; j j fondo];
	end
end

%incongruentes
for i = 1:cantPasesxColor/2
	for j = 1:cantColores 
		if entrenamiento
			colorLetra = 6;
		else
			colorLetra = randi(cantColores);
			while colorLetra == j
				colorLetra = randi(cantColores);
			end
		end
		if numExperimento == 2
			fondo = randi(cantColores);
			while fondo == colorLetra
				fondo = randi(cantColores);
			end
		else
			fondo = 5;
		end
		secuencia = [secuencia; j colorLetra fondo];
	end
end

secuencia = secuencia(randperm(size(secuencia,1)),:);
%}
