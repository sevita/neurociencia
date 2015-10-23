%variables de configuración 
resolucion=[1024 780];      %resolución de la ventana
ventana=[0 0]; 	       %posición inicial de la pantalla
clrdepth=32;		       %cantidad de bits de los colores
estimulo=4;                %cantidad de frames que dura el estímulo
frecuencia=0.8;   
duracionExperimento=8;     %medida en segundos
intervalo=0.05;			   %tiempo antes y despues del estímulo 
tamEstimulo=50;            %tamaño del estímulo

%variables de inicialización
screenNum=0;               %número de monitor   
respuesta=[]; 		       %tiempo en el cual fueron tocadas las teclas
pantalla='blanca';         %dice que pantalla mostrar
estimulos=[];              %tiempo en el cual aparecieron los estímulos
filtrado=[];

%mostar pantalla
HideCursor; 

[wPtr,rect]=Screen('OpenWindow', 0, clrdepth);

black=BlackIndex(wPtr);
dibujoEstimuloX=int64((rect(1)-tamEstimulo)/2);
dibujoEstimuloY=int64((rect(2)-tamEstimulo)/2);

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
		Screen('FillRect', wPtr, black); 
		Screen('FillRect', wPtr, [255 255 0], [0 0 50 50]); 
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

Screen('CloseAll');
ShowCursor;

for e = estimulos %filtro los datos y los resto
	aux=false;
	for r = respuesta
		if r >= e-intervalo & r <= e+intervalo+estimulo & aux==false
			filtrado = [filtrado r-e]; %si no hay respuesta a un estímulo, no se tiene en cuenta
			aux = true;
		end
	end	
end

%gráfico
plot(filtrado,'-',0,'--','r')

 