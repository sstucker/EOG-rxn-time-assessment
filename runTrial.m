function [t,y,visStim] = runTrial(inputChannel,outputChannelLeft,outputChannelRight,duration,Fs,trialType,auralStim)
%command function that sets up daq and buffers data for each trial
%author: sstucker 11/28/18

global t;
global y;
global visStim;
global bufferNo;
%--------------------------------------------------------------------------
%daq housekeeping and setup
daq.reset;
s = daq.createSession('ni');
s.DurationInSeconds = duration;
s.Rate = Fs;
s.IsContinuous = false;
input = addAnalogInputChannel(s,'Dev1',inputChannel,'Voltage');
outputR = addAnalogOutputChannel(s,'Dev1',outputChannelRight,'Voltage');
outputL = addAnalogOutputChannel(s,'Dev1',outputChannelLeft,'Voltage');
queueOutputData(s,auralStim);
lh = addlistener(s,'DataAvailable',trialType);
%--------------------------------------------------------------------------
%containers for global buffers
y = [];
t = [];
visStim = [];
bufferNo = 0;
startForeground(s);
end

