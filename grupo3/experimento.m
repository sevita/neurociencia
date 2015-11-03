
%Variables de configuración 
resolucion=[300 300];      				%resolución de la ventana
ventana=[500 200]; 	       				%posición inicial de la pantalla
clrdepth=32;		       				%cantidad de bits de los colores

%Variables del experimento
%estimulo=4;                				%cantidad de frames que dura el estímulo
%frecuencia=0.8;   
%duracionExperimento=60*3;     			%medida en segundos
numExperimento=2;
%nameFile= sprintf('target_%d.m', numExperimento);
%target=load(nameFile);				%[target, prime1, prime2, servivo/novivo, RR/NR/NN]
%setWords=target(15,5,numExperimento)


inputFile = sprintf('priming/palabras%d.csv',numExperimento)
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

cantTarget=5;
RR=[];
NR=[];
NN=[];
respuestas=[]
tiempos_target=[]; 			%0 --> ser vivo / 1 --> no vivo
cantidadRtaMalas = 0;
noKey = KbName('n');
yesKey = KbName('s'); 


%Variables de inicialización
screenNum=0;			               	%número de monitor   
respuestas=[]; 		    			   	%tiempo en el cual fueron tocadas las teclas
pantalla='blanca';						%dice que pantalla mostrar
estimulos=[];            			  	%tiempo en el cual aparecieron los estímulos
j=1;

%Mostrar pantalla
HideCursor;
[pantalla,rect]=Screen('OpenWindow', 0, 255, [0 0 resolucion(1), resolucion(2)], clrdepth);
Screen('TextSize', pantalla, 30);
[w,h] = Screen('WindowSize',pantalla);
white=BlackIndex(pantalla);

%Comienzo
PsychHID('KbQueueCreate');
Screen('FillRect', pantalla, white);
frame=Screen('GetFlipInterval' , pantalla);
DrawFormattedText(pantalla,'El experimento va a comenzar.','center','center',[255 255 255]); 
comienzo=Screen(pantalla, 'Flip');
WaitSecs(2);



%function ruido
%end

%Comienzo experimento
PsychHID('KbQueueStart');

i=1;
while i<=cantTarget
	p1 = priming1(i);
	p2 = priming2(i);
	t = target(i);
	
	%Screen('FillRect', pantalla, white);
	DrawFormattedText(pantalla,'#########','center','center',[255 255 255]); 
	Screen(pantalla, 'Flip');
	WaitSecs(0.5);

	
	DrawFormattedText(pantalla,p1{1},'center','center',[255 255 255]); 
	Screen(pantalla, 'Flip');
	WaitSecs(0.01);

	DrawFormattedText(pantalla,'#########','center','center',[255 255 255]); 
	Screen(pantalla, 'Flip');
	WaitSecs(0.5);

	
	DrawFormattedText(pantalla,p2{1},'center','center',[255 255 255]); 
	Screen(pantalla, 'Flip');
	WaitSecs(0.01);	

	DrawFormattedText(pantalla,'#########','center','center',[255 255 255]); 
	Screen(pantalla, 'Flip');
	WaitSecs(0.5);

	
	comienzo=GetSecs;
	DrawFormattedText(pantalla,t{1},'center','center',[255 255 255]); 
	Screen(pantalla, 'Flip');
	%WaitSecs(0.005);	

	presiono=false;
	j=1;
	while not(presiono)
		%DrawFormattedText(pantalla,t{1},'center','center',[255 255 255]); 
		%Screen(pantalla, 'Flip');

		[pressed, firstPress]=PsychHID('KbQueueCheck');
		if pressed
			pressedCodes=find(firstPress)
			for j=j:size(pressedCodes, 2)
				if comienzo > firstPress(pressedCodes(j))
					continue
				end
				presiono=true;
				tipoObjeto = tipo(i);

				
				respuestas= [respuestas pressedCodes]
				if (tipoObjeto{1} == 'v' && firstPress(yesKey)) || (tipoObjeto{1} == 'n' && firstPress(noKey))
					tiempos_target = [tiempos_target comienzo];
					tipoP1 = tipoPriming1(i);
					tipoP2 = tipoPriming2(i);
					if  tipoP1{1} == 'R' && tipoP2{1} == 'R' 				%RR
							RR=[RR firstPress(pressedCodes(j))];
					else 
						if tipoP1{1} == 'R' && tipoP2{1}  == 'N'				%NR
							NR=[NR firstPress(pressedCodes(j))];
						else 
							if tipoP1{1} == 'N' && tipoP2{1}  == 'N'				%NN
								NN=[NN firstPress(pressedCodes(j))];
							end
						end
					end
				else
					cantidadRtaMalas = cantidadRtaMalas + 1;
				end
			end
		end
	end
	i = i+1;
end


DrawFormattedText(pantalla,'El experimento finalizó. \n ¡Muchas gracias!','center','center',[255 255 255]); 
comienzo=Screen(pantalla, 'Flip');
WaitSecs(3);

PsychHID('KbQueueStop'); %dejo de guardar las teclas
PsychHID('KbQueueRelease'); %borro la cola
Screen('CloseAll');
ShowCursor; 


nameFile = sprintf('resultados/tiempos_RR_%d.mat', numExperimento);
save(nameFile,'RR');
nameFile = sprintf('resultados/tiempos_NR_%d.mat', numExperimento);
save(nameFile,'NR');
nameFile = sprintf('resultados/tiempos_NN_%d.mat', numExperimento);
save(nameFile,'NN');
nameFile = sprintf('resultados/tiempos_target_%d.mat', numExperimento);
save(nameFile,'tiempos_target');
nameFile = sprintf('resultados/cantPifeadas_%d.mat',numExperimento);
save(nameFile,'cantidadRtaMalas');
nameFile = sprintf('resultados/respuestas_%d.mat',numExperimento);
save(nameFile,'respuestas');
