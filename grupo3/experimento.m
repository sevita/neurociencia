
%Variables de configuración 
resolucion=[300 300];      				%resolución de la ventana
ventana=[500 200]; 	       				%posición inicial de la pantalla
clrdepth=32;		       				%cantidad de bits de los colores

colorLetras = [];


%Mostrar pantalla
HideCursor;
[pantalla,rect]=Screen('OpenWindow', 0, clrdepth); %255, [0 0 resolucion(1), resolucion(2)], );  %
Screen('TextSize', pantalla, 100);
[w,h] = Screen('WindowSize',pantalla);
white=WhiteIndex(pantalla);

%CONTRASTE
inputFile = 'priming/contraste.csv'
fid = fopen(inputFile, 'r');
T = textscan(fid, '%d%s%s%s%s%s%s', 'Delimiter',',');
fclose(fid);

target = T(2);
target = target{1};

priming1 = T(3);
priming1 = priming1{1};

priming2 = T(4);
priming2 = priming2{1};

colorLetras = [250 250 250];

cantTargets=6;

Screen('FillRect', pantalla, white);
frame=Screen('GetFlipInterval' , pantalla);
DrawFormattedText(pantalla,'Para empezar, calibremos.','center','center',[0 0 0]); 
Screen(pantalla, 'Flip');
WaitSecs(2);


i=1;
while i<=cantTargets
	p1 = priming1(i);
	p2 = priming2(i);
	t = target(i);
	
	%Screen('FillRect', pantalla, white);
	DrawFormattedText(pantalla,'#########','center','center',colorLetras); 
	%Screen('DrawTexture', pantalla, textureIndex);
	vbl = Screen(pantalla, 'Flip');
	
	DrawFormattedText(pantalla,p1{1},'center','center',colorLetras); 
	vbl = Screen(pantalla, 'Flip', vbl + 0.5 );
	
	DrawFormattedText(pantalla,'#########','center','center',colorLetras); 
	%Screen('DrawTexture', pantalla, textureIndex);
	vbl = Screen(pantalla, 'Flip', vbl + 0.05);

	DrawFormattedText(pantalla,p2{1},'center','center',colorLetras); 
	vbl = Screen(pantalla, 'Flip', vbl + 0.5 );
	
	DrawFormattedText(pantalla,'#########','center','center',colorLetras); 
	%Screen('DrawTexture', pantalla, textureIndex);
	vbl = Screen(pantalla, 'Flip', vbl + 0.05);
	
	comienzo=GetSecs;
	DrawFormattedText(pantalla,mat2str(colorLetras),'center','center',[0 0 0]); 
	Screen(pantalla, 'Flip', vbl + 0.5);

	pressed = 0
 	while pressed == 0
 		[pressed, secs, kbData] = KbCheck;
  	end
  	FlushEvents('keyDown');
	
	if find(kbData) == 88
		i = cantTargets+1
		colorLetras = colorLetras + 5
	else 
		i = i+1;
		colorLetras = colorLetras - 5;
	end
end

%EXPERIMENTO
Screen('FillRect', pantalla, white);
frame=Screen('GetFlipInterval' , pantalla);
DrawFormattedText(pantalla,'El experimento va a comenzar.','center','center',[0 0 0]); 
Screen(pantalla, 'Flip');
WaitSecs(2);


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

cantTargets=40;
tiemposDeRespuesta=[]; 		    			   	%tiempo en el que se presiono cada tecla
respuestas=[];					%teclas presionadas

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