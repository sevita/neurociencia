% TODO:
% Visual: Agregar una version con circulo chico.
% Paper: Tomar decision de que estimulos asociar 
% Duración: 3 min
% Variar frec? 


nombreExperimento='Jess.mat'
%variables de configuración 
resolucion=[300 300];      %resolución de la ventana
ventana=[500 200]; 	       %posición inicial de la pantalla
clrdepth=32;		       %cantidad de bits de los colores
estimulo=4;                %cantidad de frames que dura el estímulo
frecuencia=0.8;   
duracionExperimento=60*3;     %medida en segundos

%variables de inicialización
screenNum=0;               %número de monitor   
respuestas=[]; 		       %tiempo en el cual fueron tocadas las teclas
pantalla='blanca';         %dice que pantalla mostrar
estimulos=[];              %tiempo en el cual aparecieron los estímulos

%mostar pantalla
HideCursor; 

[wPtr,rect]=Screen('OpenWindow', 0, clrdepth); % [ventana(1) ventana(2) (resolucion(1)+ventana(1)) (resolucion(2)+ventana(2))],
[w,h] = Screen('WindowSize',wPtr)
black=BlackIndex(wPtr);
white=BlackIndex(wPtr);

PsychHID('KbQueueCreate'); %creo una cola para obtener las teclas que se presionaron

Screen('FillRect', wPtr, black);
frame=Screen('GetFlipInterval' , wPtr); 
DrawFormattedText(wPtr,'El experimento va a comenzar. \n Apreta cualquier tecla cuando veas un círculo. \n ¡Suerte!','center','center',[0 255 0]); 
comienzo=Screen(wPtr, 'Flip');
WaitSecs(3)
PsychHID('KbQueueStart');
%tiempo_inicio=GetSecs;
tic

while toc < duracionExperimento %while GetSecs<tiempo_inicio+duracionExperimento
	tiempo = toc; %tiempo=GetSecs
	[pressed, firstPress]=PsychHID('KbQueueCheck'); %guardo el tiempo en el cual se tocaron las teclas
	if pressed
		pressedCodes=find(firstPress);
		for i=1:size(pressedCodes, 2)
			respuestas = [respuestas, firstPress(pressedCodes(i))-comienzo]
		end
	end

	if mod(tiempo,frecuencia)<=(estimulo-0.1)*frame & strcmp(pantalla,'negra') %me fijo si hay que cambiar la pantalla o no
		Screen('FillRect', wPtr, white); 
		tam = 20
		Screen('FillOval', wPtr, [0 255 0], [w/2-75 h/2-75 w/2+75 h/2+75]); %, [w h rx+tam ry+tam] 	
		vbl=Screen('Flip', wPtr);
		estimulos = [estimulos vbl-comienzo];
		pantalla = 'blanca';
		estimulos; 
	else
		if mod(tiempo,frecuencia)>(estimulo-0.1)*frame & strcmp(pantalla,'blanca')
			Screen('FillRect', wPtr, black);
			vbl=Screen('Flip', wPtr); 
			pantalla = 'negra';
		end
	end 
end 
while toc < duracionExperimento + 1 %while GetSecs<duracionExperimento+1
	Screen('FillRect', wPtr, black);
	vbl=Screen('Flip', wPtr); 
end
    
PsychHID('KbQueueStop'); %dejo de guardar las teclas
PsychHID('KbQueueRelease'); %borro la cola
Screen('CloseAll');
ShowCursor; 


tiempos = []
for e = estimulos 
	inicio_rango = e - 0.3
	fin_rango = e + frame*4 + 0.3
	contador = 0

	for r = respuestas 
		if and(r >= inicio_rango, r <= fin_rango)
			contador = contador + 1
			respuesta_que_va = r
		end 
	end	
    if contador == 1 
    	tiempos = [respuesta_que_va - e, tiempos]; % tiempos << respuesta_que_va - e 
    end
end 

%plot(tiempos, 'ob')

%Para escribir el texto del comienzo
%Screen('TextFont',window, 'Courier');
%Screen('TextSize',window, 30);
%Screen('TextStyle', window, 0);
%Screen('DrawText', window, 'Here is one way to draw text', 100, 300, rand(3,1)*255);
%DrawFormattedText(window,'Here is another','center','center',[255 0 255]); 
%Screen('Flip',window)

%Distintos colores para el circulo
%Screen('FillOval', wPtr, [0 255 0]); verde
%Screen('FillOval', wPtr, [255 0 0]); rojo
%Screen('FillOval', wPtr, [0 0 255]); azul
%Screen('FillOval', wPtr, [255 255 0]); amarillo
%Screen('FillOval', wPtr, [0 255 247]); celeste
%Screen('FillOval', wPtr, [255 0 255]); rosa

%Modificando la posición (con resolución cualdrada)
%a = resolucion(1);
%b = resolucion(2);
%rx = (b-a).*rand(1000,1) + a;
%ry = (b-a).*rand(1000,1) + a;
%tam = 20
%Screen('FillOval', wPtr, [0 255 0], [rx ry rx+tam ry+tam]); 

%Grafico
tam=length(tiempos);
x = 1:tam;
yideal = zeros(1,tam);
subplot(2,1,1)
plot(x,tiempos,'o',x,yideal,'--');
xlabel('Número del intento') % label x-axis
ylabel('Tiempo') % label left y-axis

hold off;
subplot(2,1,2)
hist(tiempos,40)

save(nombreExperimento,'tiempos');
