PsychHID('KbQueueCreate');
while KbCheck; end 

PsychHID('KbQueueStart');

while 1
	[pressed, firstPress] = PsychHID('KbQueueCheck');

	if pressed
		fprintf('presionaste % \n', find(firstPress));
	end
end
PsychHID('KbQueueRelease');