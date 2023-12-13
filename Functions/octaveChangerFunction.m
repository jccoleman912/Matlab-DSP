function [outputArg1,outputArg2] = octaveChangerFunction(inputArg1,inputArg2)
% octaveChangerFunction.m
%
%   Jackson Coleman
%   Novemeber 8, 2023
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


outputArg1 = inputArg1;
outputArg2 = inputArg2;
end