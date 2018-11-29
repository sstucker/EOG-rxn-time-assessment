%command script for execution of entire experiment. variables defined here
%will matter! for BE491 F18 EOG rxn time project
%author: sstucker 11/28/18
%
%
%gives handles to listener functions
AListener = @AuralListener;
VListener = @VisualListener;
AVListener = @AuralVisualListener;
%--------------------------------------------------------------------------
samplerate = 44100
trialduration = 10
%--------------------------------------------------------------------------

[myT,myY] = runTrial('ai0','ao0',trialduration,samplerate,randLA,stimsig);

plot(myT,myY);
hold on
plot(myT,stimsig);


%listeners down here!
%--------------------------------------------------------------------------
function AuralListener(src,event)
fprintf('AURAL LISTENER WAS CALLED ');
global y;
global t;
y = [y;event.Data(:,1)];
t = [t;event.TimeStamps];
end

function VisualListener(src,event)
fprintf('VISUAL LISTENER WAS CALLED ');
global y;
global t;
global visStim;
y = [y;event.Data(:,1)];
t = [t;event.TimeStamps];
end

function AuralVisualListener(src,event)
fprintf('AURAL VISUAL LISTENER WAS CALLED ');
global y;
global t;
global visStim;
y = [y;event.Data(:,1)];
t = [t;event.TimeStamps];
end