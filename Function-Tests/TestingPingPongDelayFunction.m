clear;clc;close all;

%[xAGtr, FsAGtr] = audioread('AcGtr.wav');

%[x90, Fs90] = audioread('90BPMProTools.wav');


%length90 = length(x90);

%for n = 1:length90

 %   x90Mono(n, 1) = x90(n,1);

%end

rootdirectory = '/Users/jackdonsurfer/Documents/MATLAB/InputFiles/';

[x120, Fs120] = audioread(fullfile(rootdirectory, '120BPMProTools.wav'));

%[x160, Fs160] = audioread('160BPMProTools.wav');

%[out90, outFs90] = PingPongDelayFunction(x90Mono,Fs90,90,"eighth",...
%    true,2,2,10,"right", true);

[out, outFs] = stereoTempoDelayFunction(x120, Fs120, 120, "eighth", ...
    true, 2, "back");

%[out120, outFs120] = PingPongDelayFunction(x120, Fs120, 120, "eighth", ...
%    false, 4, 4, 4, "what", false);

%[out160, outFs160] = PingPongDelayFunction(x160,Fs160,160,"sixteenth", ...
%    true, 0,0,12,"right", true);

%[out, outFs] = PingPongDelayFunction(x90Mono,Fs90, 90, "sixteenth", ...
   %false, 4, 2, 2, "left", true);


sound(out, outFs);
