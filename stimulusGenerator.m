function stimulus = stimulusGenerator(trialDuration,stimDuration,Fs,onset,polarity)
    %Generates array of zeros of length trialDuration*Fs, with white noise
    %burst at index of onset and length stimDuration. Convolves with
    %measured HRTFs based on polarity arg.
    %author: sstucker 11/28/18
    neg45 = matfile('Subject_003_-45_0.mat');
    pos45 = matfile('Subject_003_45_0.mat');
    %----------------------------------------------------------------------
    volume = 0.1; %adjust this so as to not deafen subject!
    %----------------------------------------------------------------------
    %defines stimulus as an array of length time*samplerate with white
    %noise burst in the specified location. Putting it too close to the end
    %of the trialDuration will result in index error
    stimulus = [0:trialDuration*Fs]*0;
    stimulus(onset*Fs:onset*Fs+stimDuration*Fs) = 0.1*randn(size(stimulus(onset*Fs:onset*Fs+stimDuration*Fs)));
    %Looks at polarity input and convolves using loaded HRTFs accordingly.
    if polarity == 'L'
        stimL = conv(stimulus,pos45.hrir_left);
        stimR = conv(stimulus,pos45.hrir_right);
    elseif polarity == 'R'
        stimL = conv(stimulus,neg45.hrir_left);
        stimR = conv(stimulus,neg45.hrir_right);
    else
        fprintf('stimulusGenerator: polarity arg must be "L" or "R".');
    end
    %cats L and R channel together and transposes them. Also clips off
    %extra t introduced by convolution. This can clip off your
    %stimulus if you're not careful!
    stimulus = [stimL(1:trialDuration*Fs);stimR(1:trialDuration*Fs)]';
end