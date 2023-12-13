clc; clear; close all;

rootdirectory = '/Users/jackdonsurfer/Documents/MATLAB/InputFiles';
[in, Fs] = audioread(fullfile(rootdirectory, 'AcGtr.wav'));

semitones = -1;

[out] = tarrPitchShift(in, Fs, semitones);

sound([in; out], Fs);

plot(out);