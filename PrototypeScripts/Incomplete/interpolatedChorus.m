% Interpolated chorus prototype
% 
% April 17 2024 
% 
% A prototype script to test out and refine the DSP of a chorus/flanger
% effect with linear and cubic interpolation.
clear; clc; close all;

% Pulling the test audio file
rootdirectory = '/Users/jackdonsurfer/Documents/MATLAB/InputFiles/';
[input, Fs] = audioread(fullfile(rootdirectory, 'HoldOnJLMain_Main.01-St.wav'));

x = input(1:end, 1);

% Setting up potentially useful variables
Ts = 1/Fs;
%padLength = 2 * Fs;
%zerosPad = zeroes()
N = length(x);
t = [0:N-1]' * Ts;

% Input parameters
offsetMS = 25; % in ms
depthMS = 2; % in ms
rate = 1; % in Hz
mix = 50; % in percentage
flangerBool = false; % true: flanger, false: chorus
interpolationType = "linear"; % "linear" "cubic" or "none"
mixCoefficient = mix * 0.01; % converting percentage to decimal


% A conditional check to 
if(~flangerBool) 
    offsetSamples = round((offsetMS/1000) * Fs);
    depthSamples = round((depthMS/2000) * Fs);
else
    offsetSamples = 3; % Hypothetical values
    depthSamples = 3;
end

LFO = depthSamples * sin(2 * pi * t * rate);

delayedSignal = zeros(N, 1);

% The interator for a chorus with linear interpolation
if(interpolationType == "linear")
    for n = 1:N
        if(n > (offsetSamples + 1))
            momentaryDelay = offsetSamples - LFO(n-offsetSamples, 1);
            floorOfLFOAndOffset = floor(momentaryDelay);
            remainderOfLFOAndOffset = momentaryDelay - floorOfLFOAndOffset;
            

            delayedSignal(n , 1) = (remainderOfLFOAndOffset * x(n - floorOfLFOAndOffset - 1)) ... 
	+ ((1 - remainderOfLFOAndOffset)* x(n - floorOfLFOAndOffset));

        else
            delayedSignal(n, 1) = 0;
        end
    end

% The interator for a chorus with cubic interpolation
elseif(interpolationType == "cubic")
    for n = 1:N
        if(n > offsetSamples)
            delayedSignal(n, 1) = x(( (n-offsetSamples) + floor(LFO(n-offsetSamples)) ), 1);
        else
            delayedSignal(n, 1) = 0;
        end
    end

% The interator for a chorus without any interpolation
else
    for n = 1:N
        if(n > offsetSamples)
            delayedSignal(n, 1) = x(( (n-offsetSamples) + ...
                floor(LFO(n-offsetSamples)) ), 1);
        elseif(n > N)
            delayedSignal(n, 1) = 0;
        end
    end
end



y = (x * (1 - mixCoefficient)) + (delayedSignal * mixCoefficient);

%plot(x);

sound([y], Fs);

