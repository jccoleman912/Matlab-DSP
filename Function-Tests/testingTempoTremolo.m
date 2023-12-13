clc; clear; close all;

[x, Fs] = audioread('AcGtr.wav');

[out, outFs] = tempoTremoloFunction(x, Fs, 102.4, "eighth", false, 16);

sound((out), outFs);