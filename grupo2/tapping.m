%variables de configuración 
resolucion=[1024 780];      %resolución de la ventana
ventana=[0 0]; 	       %posición inicial de la pantalla
clrdepth=32;		       %cantidad de bits de los colores
estimulo=4;                %cantidad de frames que dura el estímulo
frecuencia=0.8;   
duracionExperimento=8;     %medida en segundos
intervalo=0.05;			   %tiempo antes y despues del estímulo 

%variables de inicialización
screenNum=0;               %número de monitor   
respuesta=[]; 		       %tiempo en el cual fueron tocadas las teclas
pantalla='blanca';         %dice que pantalla mostrar
estimulos=[];              %tiempo en el cual aparecieron los estímulos
filtrado=[];

%mostar pantalla
HideCursor; 

[wPtr,rect]=Screen('OpenWindow', screenNum, 0, [ventana(1) ventana(2) (resolucion(1)+ventana(1)) (resolucion(2)+ventana(2))], clrdepth);

black=BlackIndex(wPtr);
circle=BlackIndex(wPtr);

PsychHID('KbQueueCreate'); %creo una cola para obtener las teclas que se presionaron

Screen('FillRect', wPtr, black);
frame=Screen('GetFlipInterval' , wPtr); 
comienzo=Screen(wPtr, 'Flip');
PsychHID('KbQueueStart');
tic

while toc < duracionExperimento
	[pressed, firstPress]=PsychHID('KbQueueCheck'); %guardo el tiempo en el cual se tocaron las teclas
	if pressed
		pressedCodes=find(firstPress);
		for i=1:size(pressedCodes, 2)
			respuesta = [respuesta firstPress(pressedCodes(i))-comienzo];
		end
	end

	tiempo = toc;
	if mod(tiempo,frecuencia)<=(estimulo-0.1)*frame & strcmp(pantalla,'negra') %me fijo si hay que cambiar la pantalla o no
		Screen('FillRect', wPtr, circle); 
		Screen('FillRect', wPtr, 255, [0 0 50 50]); 
		vbl=Screen('Flip', wPtr);
		estimulos = [estimulos vbl-comienzo];
		pantalla = 'blanca';
		estimulos
	else
		if mod(tiempo,frecuencia)>(estimulo-0.1)*frame & strcmp(pantalla,'blanca')
			Screen('FillRect', wPtr, black);
			vbl=Screen('Flip', wPtr); 
			pantalla = 'negra';
		end
	end 
end 

PsychHID('KbQueueStop'); %dejo de guardar las teclas

PsychHID('KbQueueRelease'); %borro la cola

for i=1:size(estimulos, 2)
	aux=false;
	for j=1:size(respuesta, 2)
		if respuesta(j) >= estimulos(i)-intervalo & respuesta(j) <= estimulos(i)+intervalo & aux==false
			filtrado = [filtrado respuesta(j)];
			aux = true;
		end
	end	
end
%SI NO HAY RESPUESTA AL ESTÍMULO, LO TIRO

Screen('CloseAll');
ShowCursor; 