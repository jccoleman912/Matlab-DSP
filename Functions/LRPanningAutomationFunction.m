function [outputSig,outputFS] = LRPanningAutomationFunction(inSig, ...
    inFS, tempo, noteType, triplet, leftOrRightFirst, sinOrTriangle, ...
    introBuffer)
%LRPanningAutomationFunction.m 
%
%   Jackson Coleman
%   Aoril 11, 2023
%
%   This function takes a mono input signal and creates a stereo output
%   signal that will evenly pan from left to right.
% -------------------------------------------------------------------------
%   ====
%   The inSig parameter is the input audio signal.
%   This must be a one column, mono array.
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
%   The noteType parameter is a string variable that changes the rate at 
%   which the panning occurs.
%   Correct values are "thirtysecond", "sixteenth", "eighth", "quarter", 
%   "half", and "whole". 
%   All of these beat lengths assume a tempo that is over 4. 
%   The default noteType is set to "quarter".
%
%   ====
%   The triplet parameter is a boolean variable that determines if the user 
%   wants the panning to subdivide by 3 instead of 4.
%   This is accomplished by multiplying the panning time by 2/3.
%   The default value for triplet is false.
%
%   ====
%   The leftOrRightFirst paramater is a string input that will determine if
%   the signal will begin  will be the left or right channel and then
%   adjust accordingly. 
%   The user changes the direction by inputting "left" or "right".
%   The default value is set to "left".
%
%   ====
%   The sinOrTriangle parameter is a string input that will determine if
%   the signal pans based on a triangle wave or a sine wave.
%   Correct inputs are "sine" and "triangle".
%   The default value for this parameter is set to "triangle".
%   
%   ====
%   The introBuffer variable is a double variable that determines
%   how long it takes for the panning to begin in milliseconds.
%   This variable exists to ensure the user can sync up the panning with
%   whatever part of the signal they desire.
%   The default value is set to 0 ms.
%
%
% -------------------------------------------------------------------------
% =========================================================================
% -------------------------------------------------------------------------


% Assigning all of the variables with their default values.

mTempo = 120;
mNoteType = "quarter";
mTriplet = false;
mLeftOrRightFirst = "left";
mSinOrTriangle = "triangle";
mIntroBuffer = 0.0;


% Assigning the user's input paramaters to the function's internal
% variables.

x = inSig;
Fs = inFs;
mTempo = tempo;
mNoteType = noteType;
mTriplet = triplet;
mLeftOrRightFirst = leftOrRightFirst;
mSinOrTriangle = sinOrTriangle;
mIntroBuffer = introBuffer;



% Calculations to correctly sync the modulation with the tempo.

beatLength = 60/mTempo;

% -------------------------------------------------------------------------

% A series of conditional checks to assign the correct panning time
% given the user-inputted note type.


if(mNoteType == "quarter")

    period = beatLength;

elseif(mNoteType == "eighth")

    period = 0.5 * beatLength;

elseif(mNoteType == "sixteenth")

    period = 0.25 * beatLength;

elseif(mNoteType == "thirtysecond")

    period = 0.125 * beatLength;

elseif(mNoteType == "half")

    period = 2 * beatLength;

elseif(mNoteType == "whole")

    period = 4 * beatLength;

else

    period = beatLength;

end

% -------------------------------------------------------------------------


% A conditional check to see if the user wants the panning to take
% on a triplet rhythm.

if(tremTriplet)

     period = period * (2/3);
    
end


% -------------------------------------------------------------------------



% A variety of calculations and declarations to create the wave for 
% panning.

Ts = 1/Fs;

N = length(x);

t = [0:N-1]' * Ts;

if(mSinOrTriangle == "sine" || mSinOrTriangle == "sin" || ...
        mSinOrTriangle == "Sine" || mSinOrTriangle == "Sin")

    panner = (0.5 * sin(2 * pi * (1/period) * t)) + 0.5;

else

    panner = (0.5 * sawtooth(2 * pi * (1/period) * t, 1/2)) + 0.5;

end


% -------------------------------------------------------------------------


% Initializing the output array to zeros. 

outputSig = zeros(N, 1);



% A for loop to correctly pan the signal.

aL = zeros(N, 1);
aR = zeros(N, 1);

for n = 1:N


    aL(n, 1) = panner(n);
    aR(n, 1) = 1 - panner(n);

end

out = [(aL .* x), (aR .* x)];

outStraight = [(maL .* x), (maR .* x)];




outputSig = inputArg1;
outputFS = inputArg2;
end