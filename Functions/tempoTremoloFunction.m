function [outputSig,outFs] = tempoTremoloFunction(inSig, inFs, tempo, ...
    noteType, triplet, depth)
% TempoTremoloFunction.m
%
%   Jackson Coleman
%   February 6, 2023
%
%   This function creates a tremolo for both a mono and stereo signal that
%   modifies the amplitude in time with the audio input's tempo.
% -------------------------------------------------------------------------
%   ====
%   The inSig parameter is the input audio signal.
%   This must be either a one column, mono array, or a two column, stereo
%   array.
%
%   ====
%   The inFs paramater is the sampling rate of the input audio signal.
%
%   ====
%   The tempo parameter is a float value for the tempo of the inputted
%   audio signal. 
%   The default tempo is set to 120 BPM. 
%   
%   ====
%   The noteType parameter selects the appropriate tremolo time for
%   whatever note value the user desires. 
%   This is a string input; correct values are "thirtysecond", 
%   "sixteenth", "eighth", "quarter", "half", and "whole". 
%   All of these beat lengths assume a tempo that is over 4. 
%   The default noteType is set to "eighth".
%
%   ====
%   The triplet parameter is a boolean value to determine if the user 
%   wants the tremolo to subdivide by 3 instead of 4.
%   This is accomplished by multiplying the tremolo time by 2/3.
%   The default value for triplet is false.
%   
%   ====
%   The depth parameter is a float value that determines the dB level of
%   the attenuation during amplitude modulation.
%   The default value is set for 4 dB.
%
%   ====
%   The wavetype parameter changes the type of amplitude modulation.
%   The options are: "sine", "cosine", "square", "sawtooth", and
%   "triangle".
%
% -------------------------------------------------------------------------
% =========================================================================
% -------------------------------------------------------------------------


% Assigning all of the variables with their default values.

tremTempo = 120;
tremNoteType = "eighth";
tremDepthdB = 4;
tremTriplet = false;
%tremWaveType = "sine";


% Assigning the user's input paramaters to the function's internal
% variables.

x = inSig;
Fs = inFs;
tremTempo = tempo;
tremNoteType = noteType;
tremDepthdB = depth;
tremTriplet = triplet;
%tremWaveType = "sine";


% Calculations to correctly sync the modulation with the tempo.

tremBeatLength = 60/tremTempo;


% -------------------------------------------------------------------------

% A series of conditional checks to assign the correct delay time
% given the user-inputted note type.


if(tremNoteType == "quarter")

    tremPeriod = tremBeatLength;

elseif(tremNoteType == "eighth")

    tremPeriod = 0.5 * tremBeatLength;

elseif(tremNoteType == "sixteenth")

    tremPeriod = 0.25 * tremBeatLength;

elseif(tremNoteType == "thirtysecond")

    tremPeriod = 0.125 * tremBeatLength;

elseif(tremNoteType == "half")

    tremPeriod = 2 * tremBeatLength;

elseif(tremNoteType == "whole")

    tremPeriod = 4 * tremBeatLength;

else

    tremPeriod = tremBeatLength;

end


% -------------------------------------------------------------------------


% A conditional check to see if the user wants the delay period to take
% on a triplet rhythm.

if(tremTriplet)

    tremPeriod = tremPeriod * (2/3);
    
end


% -------------------------------------------------------------------------


% Converting the dB depth to a linear value.

depthLin = 1 - (10.^(-tremDepthdB/20));


% A variety of calculations and declarations to create the modulator.

Ts = 1/Fs;

N = length(x);

t = [0:N-1]' * Ts;

modulator = (0.5 * cos(2 * pi * (1/tremPeriod) * t)) + 0.5;

%sineWave = sin(2 * pi * 1000 * t);

% -------------------------------------------------------------------------


% Initializing the output array to zeros. 

outputSig = zeros(N, 1);


% Creating the correct modulator offset to correctly reflect the desired
% depth.

offset = 1 - depthLin;

tremoloSignal = (depthLin * modulator) + offset;


% A for loop to multiply the input with the modulator to create the output
% audio file.

for n = 1:N

    outputSig(n) = tremoloSignal(n) * x(n);

end

outFs = Fs;


% -------------------------------------------------------------------------

end