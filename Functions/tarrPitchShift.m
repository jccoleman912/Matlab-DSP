function [out] = tarrPitchShift(in, Fs, semitones)
%tarrPitchShift Summary of this function goes here
%   Taken from "Hack Audio" by Eric Tarr (pp 330-333)

Ts = 1/Fs;
N = length(in);                         % Total number of samples
out = zeros(N, 1);
lfo1 = zeros(N, 1);
lfo2 = zeros(N, 1);

maxDelay = Fs * 0.05;                    % Max delay time is 50 ms
buffer1 = zeros(maxDelay + 1, 1);
buffer2 = zeros(maxDelay + 1, 1);       % Initialize delay buffers

tr = 2^(semitones/12);                  % Convert semitones
dRate = 1 -tr;                          % Delay rate of change

tau = (maxDelay/abs(dRate)) * Ts;       % Period of sawtooth LFO
freq = 1/tau;                           % Frequency of LFO

fade = round((tau * Fs)/8);             % Fade length is 1/8th of a cycle
Hz = (freq/2) * (8/7);
[g1, g2] = crossfades(Fs, N, Hz, fade);




    % Initalize dlay so LFO cycles line up with crossfades

if dRate > 0                            % Pitch Decrease

    d1 = dRate * fade;
    d2 = maxDelay;
    d1Temp = d1;
    d2Temp = d2;

else                                    % Pitch Increase
   
    d1 = maxDelay - (maxDelay/8);
    d2 = 0;
    d1Temp = d1;
    d2Temp = d2;

end


% Loop to process input signal
for n = 1:N

    % Parallel delay processing of the input signal
    [out1, buffer1] = fractionalDelay(in(n, 1), buffer1, d1);
    [out2, buffer2] = fractionalDelay(in(n, 1), buffer2, d2);


    % Use crossfade gains to combine the output of each delay
    out(n,1) = g1(n,1) * out1 + g2(n,1) * out2;

    lfo1(n, 1) = d1;
    lfo2(n, 1) = d2;

    if dRate < 0
        d1 = d1 + dRate;
        d1Temp = d1Temp + dRate;
        if d1 < 0
            d1 = 0;
        end
        if d1Temp < -maxDelay * (6/8)
            d1 = maxDelay;
            d1Temp = maxDelay;
        end

        d2 = d2 + dRate;
        d2Temp = d2Temp + dRate;
        if d2 < 0
            d2 = 0;
        end
        if d2Temp < -maxDelay * (6/8)
            d2 = maxDelay;
            d2Temp = maxDelay;
        end


    else 


        d1Temp = d1Temp + dRate;
        if d1Temp > maxDelay
            d1 = 0;
            d1Temp = -maxDelay * (6/8);
        elseif d1Temp < 0
            d1 = 0;
        else
            d1 = d1 + dRate;
        end


        d2Temp = d2Temp + dRate;
        if d2Temp > maxDelay
            d2 = 0;
            d2Temp = -maxDelay * (6/8);
        elseif d2Temp < 0
            d2 = 0;
        else
            d2 = d2 + dRate;
        end
       


    end

end

end