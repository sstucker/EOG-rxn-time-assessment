function [t,y] = runTrial(inputChannel,outputChannel,duration,Fs,trialType,auralStim)
%command function that sets up daq and buffers data for each trial
%author: sstucker 11/28/18
global t;
global y;
global visStim;
%--------------------------------------------------------------------------
%daq housekeeping and setup
daq.reset
s = daq.createSession('ni');
s.DurationInSeconds = duration;
s.Rate = Fs;
s.IsContinuous = false;
input = addAnalogInputChannel(s,'Dev1',inputChannel,'Voltage')
output = addAnalogOutputChannel(s,'Dev1',outputChannel,'Voltage')
queueOutputData(s,auralStim);
lh = addlistener(s,'DataAvailable',trialType);
%--------------------------------------------------------------------------
%containers for global buffers
y = [];
t = [];
visStim = [];
startBackground(s);
end

