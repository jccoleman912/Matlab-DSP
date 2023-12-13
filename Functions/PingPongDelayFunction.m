function [outputSig, outFs] = PingPongDelayFunction(inSig, inFs, tempo, ...
    noteType, triplet, c2LdBDrop, l2RdBDrop, r2LdBDrop, leftOrRightFirst, ...
    dryWetMixBoolean)
% PingPongDelayFunction.m
%
%   Jackson Coleman
%   February 4, 2023
%
%   This function creates a ping pong delay in the tempo of the
%   input wav file, with options for different delay times based on
%   note lengths. 
%   This only works for mono audio signals.
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
%   The noteType parameter selects the appropriate delay time for
%   whatever note value the user desires. 
%   This is a string input; correct
%   values are "thirtysecond", "sixteenth", "eighth", "quarter", "half",
%   and "whole". 
%   All of these beat lengths assume a tempo that is over 4. 
%   The default noteType is set to "eighth".
%
%   ====
%   The triplet parameter is a boolean value to determine if the user 
%   wants the signal to subdivide by 3 instead of 4.
%   This is accomplished by multiplying the delay time by 2/3.
%   The default value for triplet is false.
%   
%   ====
%   The c2LdBDrop paramater is the dB drop level from the center input
%   to the left delay channel. 
%   The l2RdBDrop parameter is the dB drop level from the left delay 
%   channel to the right delay channel. 
%   The r2LdBDrop parameter is the dB drop level from the right delay 
%   channel back to the left delay channel.
%   All of these parameters take float values as inputs.
%   The user inputs a positive value to indicate the dB drop (an input of 
%   6 will result in a 6dB loss).
%   If the user inputs a negative value, the signal will decrease by 0dB.
%   The default value for all of these paramaters is 6dB.
%   
%   ====
%   The leftOrRightFirst paramater is a string input that will determine if
%   the first delay channel will be the left or right channel and then
%   adjust accordingly. 
%   The user changes the direction by inputting "left" or "right".
%   The default value is set to "left".
%   The previous three parameters will be flipped if the user changes the
%   intial delay to be in the right channel. 
%   
%   ====
%   The dryWetMixBoolean variable is a boolen variable that determines
%   if the output is both the input and delay together or just the delay.
%   For the output file to have both, the value is set to true, while false
%   will cause only the stereo ping pong delay to be sent as the output.
%   The default value is set to true.
%
%
% -------------------------------------------------------------------------
% =========================================================================
% -------------------------------------------------------------------------


% Assigning all of the variables with their default values.

mTempo = 120;
mNoteType = "eighth";
mTriplet = false;
mC2LdBDrop = 6;
mL2RdBDrop = 6;
mR2LdBDrop = 6;
mLeftOrRightFirst = "left";
mDryWetMixBoolean = true;


% Assigning the user's input paramaters to the function's internal
% variables.

x = inSig;
Fs = inFs;
mTempo = tempo;
mNoteType = noteType;
mTriplet = triplet;
mC2LdBDrop = c2LdBDrop;
mL2RdBDrop = l2RdBDrop;
mR2LdBDrop = r2LdBDrop;
mLeftOrRightFirst = leftOrRightFirst;
mDryWetMixBoolean = dryWetMixBoolean;


% Determining how long one beat would be given the tempo. 

beatLength = 60/mTempo;


% -------------------------------------------------------------------------


% A series of conditional checks to assign the correct delay time
% given the user-inputted note type.

if(mNoteType == "sixteenth")
    
    delayPeriod = 0.25 * beatLength;

elseif(mNoteType == "eighth")

    delayPeriod = 0.5 * beatLength;

elseif(mNoteType == "quarter") 

    delayPeriod = beatLength;

elseif(mNoteType == "thirtysecond")

    delayPeriod = 0.125 * beatLength;

elseif(mNoteType == "half")

    delayPeriod = 2 * beatLength;

elseif(mNoteType == "whole")

    delayPeriod = 4 * beatLength;

else

    delayPeriod = 0.5 * beatLength;

end


% -------------------------------------------------------------------------


% A conditional check to see if the user wants the delay period to take
% on a triplet rhythm.

if(mTriplet) % || mTriplet == "triplet" || mTriplet == "3" || ...
       % mTriplet == "t")

    delayPeriod = delayPeriod * (2/3);
    
end

% -------------------------------------------------------------------------


% Conditional checks to ensure the user won't create an unstable feedback
% system.

if(mC2LdBDrop < 0)
    mC2LdBDrop = 0;
end

if(mL2RdBDrop < 0)
    mL2RdBDrop = 0;
end

if(mR2LdBDrop < 0)
    mR2LdBDrop = 0;
end


% -------------------------------------------------------------------------


% Various calculations to later be used when the delay is processed.

Ts = 1/Fs;

c2LLinDrop = 10.^(-mC2LdBDrop / 20);
l2RLinDrop = 10.^(-mL2RdBDrop / 20);
r2LLinDrop = 10.^(-mR2LdBDrop / 20);

delayInSamples = round(delayPeriod * Fs);

N = length(x);


% -------------------------------------------------------------------------


% The creation of an ending buffer to ensure the ping pong delay does not
% prematurely clip off at the end.

n = 1;
k = 0;

% 1e-03 is -60dB; once the delay drops below this threshold, the output
% file will end.

while(n > 1e-03)

    n = n * l2RLinDrop;
    k = k + 1;

    if(n > 1e-03)

        n = n * r2LLinDrop;
        k = k + 1;

    end
end

endingBuffer = delayInSamples * k;


% Initializing the left and right output channels.

yLeft = zeros((N + endingBuffer), 1);
yRight = zeros((N + endingBuffer), 1);

bufferedInSig = [x, x];
bufferedInSig = [bufferedInSig; zeros((endingBuffer), 2)];


% -------------------------------------------------------------------------


% A for loop to correctly add the delayed signals to the left and right
% channels.

for n = 1:(N + endingBuffer)

    if(n > delayInSamples)
        yLeft(n) = (c2LLinDrop * bufferedInSig(n-delayInSamples)) ...
            + (r2LLinDrop * yRight(n-delayInSamples));
        yRight(n) = l2RLinDrop * yLeft(n-delayInSamples);
    end

end


% Both channels are combined into one stereo signal.
% This is where the user's preference of the left or right channel
% containing the intial delay is considered.

if(mLeftOrRightFirst == "right" || mLeftOrRightFirst == "Right" ...
        || mLeftOrRightFirst == "r" || mLeftOrRightFirst == "R")

    y = [yRight, yLeft];

else

    y = [yLeft, yRight];

end


% This is where the user's desire for the output signal to only be the
% delay channels or to be the mix between the dry and wet signals comes
% into consideration.

if(~mDryWetMixBoolean)

     outputSig = y;

else

    % Adding the length of the buffer to the input signal so the input and the
    % delay can correctly concatenate.

    outputSig = bufferedInSig + y;

end

outFs = inFs;

end