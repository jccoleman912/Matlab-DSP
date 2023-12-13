% Audio Spectrogram
% This script is a template for a spectrogram
% display of an audio signal.

% Taken exactly from "Hack Audio" by Eric Tarr (pp 295-296)


clear; clc; close all;

rootdirectory = '/Users/jackdonsurfer/Documents/MATLAB/InputFiles/';
[x, Fs] = audioread(fullfile(rootdirectory, 'AcGtr.wav'));

% Waveform
t = [0:length(x) - 1].' * (1/Fs);
subplot(3,1,1);
plot(t, x); axis([0 (length(x) * (1/Fs)) -1 1]);

% Spectrogram
nfft = 2048; % length of each time frame

window = hann(nfft); % Calculated windowing function

overlap = 128; % Number of samples for frame overlap

% Using the built-in spectrogram function
[y, f, t, p] = spectrogram(x, window, overlap, nfft, Fs);

% Lower Subplot
subplot(3, 1, 2:3);
surf(t,f,10 * log10(p), 'EdgeColor','none');

% Rotate the spectrogram to look like typical audio visualization
axis xy; axis tight; view(0, 90);
xlabel('Time (sec.)'); ylabel('Frequency (Hz)');