
%Variables de configuración 
resolucion=[300 300];      				%resolución de la ventana
ventana=[500 200]; 	       				%posición inicial de la pantalla
clrdepth=32;		       				%cantidad de bits de los colores

%Variables del experimento
%estimulo=4;                				%cantidad de frames que dura el estímulo
%frecuencia=0.8;   
%duracionExperimento=60*3;     			%medida en segundos
numeroExperiment=load('numExperimento.mat');
nameFile= sprintf('target_%d.m', numExperimento);
setWords=load(nameFile);				%[target, prime1, prime2, servivo/novivo, RR/NR/NN]
cantTarget=length(setWords);
relacionadas=[]
relacionadayno=[]
norelacionada=[]


%Variables de inicialización
screenNum=0;			               	%número de monitor   
respuestas=[]; 		    			   	%tiempo en el cual fueron tocadas las teclas
pantalla='blanca';						%dice que pantalla mostrar
estimulos=[];            			  	%tiempo en el cual aparecieron los estímulos
j=1;

%Mostrar pantalla
HideCursor;
[pantalla,rect]=Screen('OpenWindow', 0, clrdepth); 
[w,h] = Screen('WindowSize',pantalla);
white=BlackIndex(pantalla);
ruido=DrawFormattedText(pantalla,'#########','center','center',0); 

%Comienzo
PsychHID('KbQueueCreate');
Screen('FillRect', pantalla, white);
frame=Screen('GetFlipInterval' , pantalla);
DrawFormattedText(pantalla,'El experimento va a comenzar.','center','center',0); 
comienzo=Screen(pantalla, 'Flip');
WaitSecs(3)

%Instrucciones
DrawFormattedText(pantalla,'	Verá aparecer en pantalla una palabra. 
						\n 	Frente a ella decida, tan rápido como sea posible, si corresponde a un ser vivo o no e indíquelo según:
						\n 	- ser vivo: flecha a la derecha
						\n 	- ser no vivo: flecha a la izquierda','center','center',[0 255 0]); 
comienzo=Screen(pantalla, 'Flip');
WaitSecs(4)

function ruido
		Screen('FillRect', pantalla, white);
		DrawFormattedText(pantalla,'#########','center','center',0); 
		Screen(pantalla, 'Flip');
		WaitSecs(0,0167)
end

%Comienzo experimento
PsychHID('KbQueueStart');
tiempo_inicio=GetSecs;

for i in cantTarget do
	comienzo=GetSecs;
	
	ruido

	Screen('FillRect', pantalla, white);
	priming1=setWords(i,2)
	DrawFormattedText(pantalla,priming1,'center','center',0); 
	Screen(pantalla, 'Flip');
	WaitSecs(0,05)

	ruido

	Screen('FillRect', pantalla, white);
	priming2=setWords(i,3)
	DrawFormattedText(pantalla,priming2,'center','center',0); 
	Screen(pantalla, 'Flip');
	WaitSecs(0,05)	

	ruido

	noKey = KbName('leftArrow'); 
	yesKey = KbName('rigthArrow'); 
	notPress=true;
	while notPress
		Screen('FillRect', pantalla, white);
		target=setWords(i,1)
		DrawFormattedText(pantalla,target,'center','center',0); 
		Screen(pantalla, 'Flip');
		WaitSecs(0,05)


		[pressed, firstPress]=PsychHID('KbQueueCheck');
		if pressed
			pressedTime=find(firstPress);
			pressedKey=KbName(firstPress);
			lastPressedTime=firstPress(pressedCodes(end))-comienzo
			notPress=false;
			if setWords(i,4) == 0
				if firstPress(yesKey)
					%agregar GetSecs a algun lado
				end
			else
				if firstPress(noKey)
					if setWords(i,5)==0 			%RR
						relacionadas=[relacionadas lastPressedTime]
					else if setWords(i,5)==1				%NR
						relacionadayno=[relacionadayno lastPressedTime]
					else if setWords(i,5)==2				%NN
						norelacionada=[norelacionada lastPressedTime]
					end
					%agregar GetSecs en otro lado 
				end
			end
		end
	end

end

nameFile=
save(relacionadas,'relacionadas');












end

