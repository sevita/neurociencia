
%Variables de configuración 
resolucion=[300 300];      				%resolución de la ventana
ventana=[500 200]; 	       				%posición inicial de la pantalla
clrdepth=32;		       				%cantidad de bits de los colores

%Variables del experimento
%estimulo=4;                				%cantidad de frames que dura el estímulo
%frecuencia=0.8;   
%duracionExperimento=60*3;     			%medida en segundos
%nameFile= sprintf('target_%d.m', sujeto);
%target=load(nameFile);				%[target, prime1, prime2, servivo/novivo, RR/NR/NN]
%setWords=target(15,5,sujeto)


inputFile = sprintf('priming/palabras%d.csv',sujeto)
fid = fopen(inputFile, 'r');
T = textscan(fid, '%d%s%s%s%s%s%s', 'Delimiter',',');
fclose(fid);

target = T(2);
target = target{1};

priming1 = T(3);
priming1 = priming1{1};

priming2 = T(4);
priming2 = priming2{1};

colorLetras = [color color color];

cantTargets=40;
%noKey = KbName('n');
%yesKey = KbName('s'); 

%Variables de inicialización
tiemposDeRespuesta=[]; 		    			   	%tiempo en el que se presiono cada tecla
respuestas=[];					%teclas presionadas

%Mostrar pantalla
HideCursor;
[pantalla,rect]=Screen('OpenWindow', 0, clrdepth); % 255, [0 0 resolucion(1), resolucion(2)], 
Screen('TextSize', pantalla, 100);
[w,h] = Screen('WindowSize',pantalla);
white=WhiteIndex(pantalla);

%Comienzo
Screen('FillRect', pantalla, white);
frame=Screen('GetFlipInterval' , pantalla);
DrawFormattedText(pantalla,'El experimento va a comenzar.','center','center',[0 0 0]); 
Screen(pantalla, 'Flip');
WaitSecs(2);


i=1;
while i<=cantTargets
	p1 = priming1(i);
	p2 = priming2(i);
	t = target(i);
	
	%Screen('FillRect', pantalla, white);
	DrawFormattedText(pantalla,'############','center','center',colorLetras); 
	%Screen('DrawTexture', pantalla, textureIndex);
	vbl = Screen(pantalla, 'Flip');
	
	DrawFormattedText(pantalla,p1{1},'center','center',colorLetras); 
	vbl = Screen(pantalla, 'Flip', vbl + 0.5 );
	
	DrawFormattedText(pantalla,'############','center','center',colorLetras); 
	%Screen('DrawTexture', pantalla, textureIndex);
	vbl = Screen(pantalla, 'Flip', vbl + 0.05);

	DrawFormattedText(pantalla,p2{1},'center','center',colorLetras); 
	vbl = Screen(pantalla, 'Flip', vbl + 0.5 );
	
	DrawFormattedText(pantalla,'############','center','center',colorLetras); 
	%Screen('DrawTexture', pantalla, textureIndex);
	vbl = Screen(pantalla, 'Flip', vbl + 0.05);
	
	comienzo=GetSecs;
	DrawFormattedText(pantalla,t{1},'center','center',colorLetras); 
	Screen(pantalla, 'Flip', vbl + 0.5);

	pressed = 0;
 	while pressed == 0
 		[pressed, secs, kbData] = KbCheck;
  	end
  	tiempo = secs - comienzo;
  	FlushEvents('keyDown');
	
	tiemposDeRespuesta= [tiemposDeRespuesta tiempo];
	respuestas = [respuestas find(kbData)];

	i = i+1;
end


DrawFormattedText(pantalla,'El experimento finalizó. \n ¡Muchas gracias!','center','center',[0 0 0]); 
Screen(pantalla, 'Flip');
WaitSecs(3);

Screen('CloseAll');
ShowCursor; 


nameFile = sprintf('resultados/tiemposDeRespuesta_%d.mat',sujeto);
save(nameFile,'tiemposDeRespuesta');

nameFile = sprintf('resultados/respuestas_%d.mat',sujeto);
save(nameFile,'respuestas');