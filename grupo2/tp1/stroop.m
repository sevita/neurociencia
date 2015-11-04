%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  PARÁMETROS                  %%
%%----------------------------------------------%%
%%     numExperimento=1 es con fondo NEGRO      %%
%%   numExperimento=2 es con fondo DE COLORES   %%   
%%             sexo=1 es MASCULINO              %% 
%%              sexo=2 es FEMENINO              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [resultados]=stroop(numExperimento, sexo)
%Screen('Preference','SkipSyncTests', 1);
%variables de configuración 
KbName('UnifyKeyNames');
clrdepth=32;		       %cantidad de bits de los colores
duracionEstimulo=4;     %duración máxima de cada uno de los estímulos en segundos
cantPasesxColorEntrenamiento=4;  %cantidad de veces que aparece cada color en el entrenamiento
cantPasesxColorExperimento=16;  %cantidad de veces que aparece cada color en el experimento 1
cantColores=4;                 %cantidad de colores que tiene el experimento

font='Times New Roman';     %tipo de letra
tamanioDelTexto=45;			%tamaño de las palabras de los estímulos
nombreColores=char('ROJO','AZUL','VERDE','AMARILLO','NEGRO','BLANCO'); %palabras que aparecen en el estímulo
colores=[[255 0 0]; [0 0 255]; [0 204 0]; [204 204 0]; [0 0 0]; [255 255 255]]; %palabras que aparecen en el estímulo

%definiciones
resultados=[]; %los estimulos se guardan por fila (|tipo_experimento|sexo|N°_estímulo|nombre|color|colorFondo|tiempoRespuesta|respuesta|)
scanList=[KbName('LeftArrow') KbName('RightArrow')];

%definición de la pantalla
HideCursor; 
[wPtr,rect]=Screen('OpenWindow', 0, clrdepth);  %creación de la ventana
Screen ('TextFont', wPtr, font); % define el font
Screen('TextSize',wPtr, tamanioDelTexto); % define el tamaño de la letra

%muestro la pantalla con la explicación 
Screen('FillRect', wPtr, colores(5,:));      %definición del color de fondo
DrawFormattedText(wPtr,'PRESTÁ ATENCIÓN \n Presioná el círculo VERDE si la  PALABRA coincide con el COLOR con el que está ESCRITA \n el círculo ROJO si la  PALABRA NO coincide con el COLOR con el que está ESCRITA','center','center',colores(6,:)); 
comienzo=Screen(wPtr, 'Flip');				  %colocamos la pantalla 
WaitSecs(10);

font='Times New Roman';     %tipo de letra
tamanioDelTexto=100;			%tamaño de las palabras de los estímulos
Screen('TextSize',wPtr, tamanioDelTexto); % define el tamaño de la letra

%experimento
secuencia=generadorDeSecuencias(cantPasesxColorEntrenamiento,cantColores,true,numExperimento)

estimulo=1;
while estimulo <= cantPasesxColorEntrenamiento*cantColores

	pressed=0;
	%creo la pantalla y la muestro
	Screen('FillRect', wPtr, colores(secuencia(estimulo,3),:));      %definición del color de fondo
	DrawFormattedText(wPtr,nombreColores(secuencia(estimulo,1),:),'center','center',colores(secuencia(estimulo,2),:)); 
	comienzo=Screen(wPtr, 'Flip');				  %colocamos la pantalla 

	%espero la respuesta
	tEnd=GetSecs+duracionEstimulo;
 	while pressed == 0 & GetSecs<tEnd
		[pressed, secs, kbData] = KbCheck;
  	end

  	%calculamos los datos
  	tiempoDeRespuesta = secs-comienzo;
   	if kbData(scanList(1)) == 1 %tocó izq
   		congruente=0;
   	elseif kbData(scanList(2)) == 1 %tocó der
   		congruente=1;
   	else                  %time out o error de tecla
   		congruente=2;
    end

  	while pressed == 1 
		[pressed, secs, kbData] = KbCheck;
  	end
  	FlushEvents('keyDown');
  	resultados=[resultados; numExperimento sexo estimulo secuencia(estimulo,1) secuencia(estimulo,2) secuencia(estimulo,3) tiempoDeRespuesta congruente];
	estimulo = estimulo +1;
end
font='Times New Roman';     %tipo de letra
tamanioDelTexto=45;			%tamaño de las palabras de los estímulos
Screen('TextSize',wPtr, tamanioDelTexto); % define el tamaño de la letra

%muestro la pantalla con la explicación 
Screen('FillRect', wPtr, colores(5,:));      %definición del color de fondo
DrawFormattedText(wPtr,'PRESTÁ ATENCIÓN \n Presioná el círculo VERDE si la  PALABRA coincide con el COLOR con el que está ESCRITA \n el círculo ROJO si la  PALABRA NO coincide con el COLOR con el que está ESCRITA','center','center',colores(6,:)); 
comienzo=Screen(wPtr, 'Flip');				  %colocamos la pantalla 
WaitSecs(10);

%experimento
secuencia=generadorDeSecuencias(cantPasesxColorExperimento,cantColores,false,numExperimento)
font='Times New Roman';     %tipo de letra
tamanioDelTexto=100;			%tamaño de las palabras de los estímulos
Screen('TextSize',wPtr, tamanioDelTexto); % define el tamaño de la letra

while estimulo <= cantPasesxColorEntrenamiento*cantColores+cantPasesxColorExperimento*cantColores
    
    aux=estimulo-cantPasesxColorEntrenamiento*cantColores;
	pressed=0;
	%creo la pantalla y la muestro
	Screen('FillRect', wPtr, colores(secuencia(aux,3),:));      %definición del color de fondo
	DrawFormattedText(wPtr,nombreColores(secuencia(aux,1),:),'center','center',colores(secuencia(aux,2),:)); 
	comienzo=Screen(wPtr, 'Flip');				  %colocamos la pantalla 

	%espero la respuesta
	tEnd=GetSecs+duracionEstimulo;
 	while pressed == 0 & GetSecs<tEnd
		[pressed, secs, kbData] = KbCheck;
  	end

  	%calculamos los datos
  	tiempoDeRespuesta = secs-comienzo;
   	if kbData(scanList(1)) == 1 %tocó izq
   		congruente=0;
   	elseif kbData(scanList(2)) == 1 %tocó der
   		congruente=1;
   	else                  %time out o error de tecla
   		congruente=2;
    end

  	while pressed == 1 
		[pressed, secs, kbData] = KbCheck;
  	end
  	FlushEvents('keyDown');
  	resultados=[resultados; numExperimento sexo estimulo secuencia(aux,1) secuencia(aux,2) secuencia(aux,3) tiempoDeRespuesta congruente];
	estimulo = estimulo +1;
end

%almacenamiento de datos en archivo
fid=fopen('resultados.txt','a');
for i=1:cantPasesxColorEntrenamiento*cantColores+cantPasesxColorExperimento*cantColores
	fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',resultados(i,1),resultados(i,2),resultados(i,3),resultados(i,4),resultados(i,5),resultados(i,6),resultados(i,7),resultados(i,8));
end
fclose(fid);

%muestro la pantalla con la explicación 
Screen('FillRect', wPtr, colores(5,:));      %definición del color de fondo
DrawFormattedText(wPtr,'¡GRACIAS! :)','center','center',colores(6,:)); 
comienzo=Screen(wPtr, 'Flip');				  %colocamos la pantalla 
WaitSecs(1);

Screen('CloseAll');
ShowCursor;


%{
[archivo,ruta]=uigetfile('resultados.txt','ABRIR ARCHIVO');
if archivo==0
    return;
else
fid =fopen([ruta archivo],'r');
A=textscan(fid,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f','headerlines',1);
A=cell2mat(A);
fclose(fid);
display(A)
end	

%}