% Chorus effect prototype

% December 4, 2023

% A prototype for a chorus effect to be used in a JUCE plug in.
% This version does not use interpolation.

clear; clc; close all;

rootdirectory = '/Users/jackdonsurfer/Documents/MATLAB/InputFiles/';
[x, Fs] = audioread(fullfile(rootdirectory, 'AcGtr.wav'));

% These are the parameters
depth = 5; % 4-20 ms
rate = 3; % Speed of the LFO, 0.1-10
offset = 15; % 10-50 ms

% Initializing variables to be used for later
Ts = 1/Fs;

N = length(x);

t = [0:N-1]' * Ts;

% Converting earlier parameters into new units
depthSamples =  floor(Fs * (depth/1000));
%depthSamples = depth;

delayedSignal = zeros(N, 1);

offsetSamples = floor(Fs * (offset/1000));

% Creating the LFO (low frquency oscillator)

LFO = floor((depthSamples/2) * sin(2 * pi * rate * t));

% For loop to set up the variable delay

for n = 1:N
    if n > offsetSamples
    delayedSignal(n, 1) = x(((n - offsetSamples) + LFO(n)), 1);
    else 
        delayedSignal(n,1) = 0;
    end
end

y = x + delayedSignal;
sound(y, Fs);

plot(delayedSignal);
