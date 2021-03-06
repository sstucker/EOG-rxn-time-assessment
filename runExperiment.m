%command script for execution of entire experiment. variables defined here
%will matter! for BE491 F18 EOG rxn time project
%author: sstucker 11/28/18
%
%some global stuff: visual stim figure and visual cue time
global experimentScreen
global bufferCue
global visualPolarity
%gives handles to listener functions
AListener = @AuralListener;
AVListener = @AuralVisualListener;
%--------------------------------------------------------------------------
sampleRate = 500; %IMPORTANT: SEE BELOW
trialDuration = 10; %IMPORTANT: BUFFERS FOR VISUAL STUFF BASED ON 10s TRIAL
auralStimDuration = 0.5;
inputChannel = 'ai0';
outputChannelL = 'ao1';
outputChannelR = 'ao0';
bufferCue = 60;
%--------------------------------------------------------------------------
%EXPERIMENT
nullStim = zeros(trialDuration*sampleRate,2);
A1onset = randi([3,6]);
A2onset = randi([3,6]);
A3onset = randi([3,6]);
V1onset = randi([3,6]);
V2onset = randi([3,6]);
V3onset = randi([3,6]);
B1onset = randi([3,6]);
B2onset = randi([3,6]);
B3onset = randi([3,6]);
polchoices = ['R','L'];
A1polarity = polchoices(randi([1,2]));
A2polarity = polchoices(randi([1,2]));
A3polarity = polchoices(randi([1,2]));
V1polarity = polchoices(randi([1,2]));
V2polarity = polchoices(randi([1,2]));
V3polarity = polchoices(randi([1,2]));
B1polarity = polchoices(randi([1,2]));
B2polarity = polchoices(randi([1,2]));
B3polarity = polchoices(randi([1,2]));
trials = [...
{'A',stimulusGenerator(trialDuration,auralStimDuration,sampleRate,A1onset,A1polarity),A1onset,A1polarity};...         %AURAL 1 [type,stim,onset,polarity}
{'A',stimulusGenerator(trialDuration,auralStimDuration,sampleRate,A2onset,A2polarity),A2onset,A2polarity};...         %AURAL 2
{'A',stimulusGenerator(trialDuration,auralStimDuration,sampleRate,A3onset,A3polarity),A3onset,A3polarity};...         %AURAL 3
{'V',nullStim,V1onset,V1polarity};...                                                                                 %VISUAL 1
{'V',nullStim,V2onset,V2polarity};...                                                                                 %VISUAL 2
{'V',nullStim,V3onset,V3polarity};...                                                                                 %VISUAL 3
{'B',stimulusGenerator(trialDuration,auralStimDuration,sampleRate,B1onset,B1polarity),B1onset,B1polarity};...    %AURAL-VISUAL 1
{'B',stimulusGenerator(trialDuration,auralStimDuration,sampleRate,B2onset,B2polarity),B2onset,B2polarity};...    %AURAL-VISUAL 2
{'B',stimulusGenerator(trialDuration,auralStimDuration,sampleRate,B3onset,B3polarity),B3onset,B3polarity}...     %AURAL-VISUAL 3
];
experimentScreen = visualCue;
%[type,aural_stim,time,EOGvoltage,visual_stim]
BigData = cell(9,5);
experimentScreen.init
pause(3)
for i = (1:9)
    trial = trials(i,:);
    if trial{1} == 'A'
        fprintf('RUNNING AN A TRIAL :) ')
        experimentScreen.hideInstructions
        stimsig = trial{2};
        BigData{i,1} = trial(1);
        BigData{i,2} = stimsig; 
        [trialt,trialy,trial_Vstim] = runTrial(inputChannel,outputChannelL,outputChannelR,trialDuration,sampleRate,AListener,stimsig);
        BigData(i,3:5)= {trialt,trialy,trial_Vstim} 
        experimentScreen.showInstructions
    elseif trial{1} == 'V' || trial{1} == 'B'
        fprintf('RUNNING AN B TRIAL :) ')
        experimentScreen.hideInstructions
        stimsig = trial{2};
        visualPolarity = trials{i,4};
        bufferCue = trials{i,3};
        BigData{i,1} = trial(1);
        BigData{i,2} = stimsig;
        [trialt,trialy,trial_Vstim] = runTrial(inputChannel,outputChannelL,outputChannelR,trialDuration,sampleRate,AVListener,stimsig);
        BigData(i,3:5)= {trialt,trialy,trial_Vstim} 
        experimentScreen.hideCue
        experimentScreen.centerCue
        experimentScreen.showInstructions
    else
        fprintf('Invalid type argument in trials array!');
    end
end
%--------------------------------------------------------------------------

function AuralListener(src,event)
global y;
global t;
y = [y;event.Data(:,1)];
t = [t;event.TimeStamps];
end
function AuralVisualListener(src,event)
global experimentScreen;
global y;
global t;
global visStim;
global bufferNo;
global bufferCue;
global visualPolarity;
VBuffer = zeros(size(event.TimeStamps));
if bufferNo == 60
    if visualPolarity == 'L'
        experimentScreen.leftCue;
    elseif visualPolarity == 'R'
        experimentScreen.rightCue;
    else
        fprintf('visualPolarity is invalid')
    end
    VBuffer(1) = 1;
    visStim = [visStim;VBuffer];
else
    visStim = [visStim;VBuffer];
end
y = [y;event.Data(:,1)];
t = [t;event.TimeStamps];
bufferNo = bufferNo + 1;
end