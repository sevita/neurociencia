
%Variables de configuración 
resolucion=[300 300];      				%resolución de la ventana
ventana=[500 200]; 	       				%posición inicial de la pantalla
clrdepth=32;		       				%cantidad de bits de los colores

%Variables del experimento
%estimulo=4;                				%cantidad de frames que dura el estímulo
%frecuencia=0.8;   
%duracionExperimento=60*3;     			%medida en segundos
sujeto=1;
%nameFile= sprintf('target_%d.m', sujeto);
%target=load(nameFile);				%[target, prime1, prime2, servivo/novivo, RR/NR/NN]
%setWords=target(15,5,sujeto)


inputFile = sprintf('priming/palabras%d.csv',sujeto)
fid = fopen(inputFile, 'r');
T = textscan(fid, '%s%s%s%s%s%s', 'Delimiter',',');
fclose(fid);

target = T(1);
target = T{1};

priming1 = T(2);
priming1 = priming1{1};

priming2 = T(3);
priming2 = priming2{1};

tipo = T(4);
tipo = tipo{1};

tipoPriming1 = T(5);
tipoPriming1 = tipoPriming1{1};

tipoPriming2 = T(6);
tipoPriming2 = tipoPriming2{1};

colorLetras = [240 240 240];

cantTarget=4;
RR=[];
NR=[];
NN=[];
tiemposTarget=[]; 			%0 --> ser vivo / 1 --> no vivo
cantidadRtaMalas = 0;
noKey = KbName('n');
yesKey = KbName('s'); 


%Variables de inicialización
screenNum=0;			               	%número de monitor   
pantalla='blanca';						%dice que pantalla mostrar

tiemposDeRespuesta=[]; 		    			   	%tiempo en el que se presiono cada tecla
respuestas=[];					%teclas presionadas
estimulos=[];            			  	%tiempo en el cual aparecieron los estímulos


%Mostrar pantalla
HideCursor;
[pantalla,rect]=Screen('OpenWindow', 0, clrdepth); % 255, [0 0 resolucion(1), resolucion(2)], 
Screen('TextSize', pantalla, 100);
[w,h] = Screen('WindowSize',pantalla);
white=WhiteIndex(pantalla);

%Comienzo
Screen('FillRect', pantalla, white);
frame=Screen('GetFlipInterval' , pantalla);
DrawFormattedText(pantalla,'El experimento va a comenzar.','center','center',colorLetras); 
Screen(pantalla, 'Flip');
WaitSecs(2);


i=1;
while i<=cantTarget
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
	vbl = Screen(pantalla, 'Flip', vbl + 0.03);

	DrawFormattedText(pantalla,p2{1},'center','center',colorLetras); 
	vbl = Screen(pantalla, 'Flip', vbl + 0.5 );
	
	DrawFormattedText(pantalla,'#########','center','center',colorLetras); 
	%Screen('DrawTexture', pantalla, textureIndex);
	vbl = Screen(pantalla, 'Flip', vbl + 0.03);
	
	comienzo=GetSecs;
	DrawFormattedText(pantalla,t{1},'center','center',colorLetras); 
	Screen(pantalla, 'Flip', vbl + 0.5);

	pressed = 0
 	while pressed == 0
 		[pressed, secs, kbData] = KbCheck;
  	end
  	tiempo = secs - comienzo
  	FlushEvents('keyDown');
	
	tiemposDeRespuesta= [tiemposDeRespuesta tiempo];
	respuestas = [respuestas find(kbData)];

	i = i+1;
end


DrawFormattedText(pantalla,'El experimento finalizó. \n ¡Muchas gracias!','center','center',colorLetras); 
Screen(pantalla, 'Flip');
WaitSecs(3);

Screen('CloseAll');
ShowCursor; 


nameFile = sprintf('resultados/tiemposDeRespuesta_%d.mat',sujeto);
save(nameFile,'tiemposDeRespuesta');

nameFile = sprintf('resultados/respuestas_%d.mat',sujeto);
save(nameFile,'respuestas');