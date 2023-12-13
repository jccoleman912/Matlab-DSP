% Copied from "Hack Audio" by Eric Tarr (pp 318-319)

% A basic example of pitch shifting down an octave 
% using modulating delay

clc; clear; close all;

% Synthesize 1 Hz Test Signal
Fs = 48000;
Ts = 1/Fs;
t = [0:Ts:1].';
f = 1;
in = sin(2 * pi * f * t);
x = [in; zeros(Fs, 1)]; % Pad because the output will be twice as long

% Initialize loop for pitch decrease
d = 0;          % Initially start with no delay
N = length(x);
y = zeros(N, 1);
buffer = zeros(Fs * 2, 1);

for n = 1:N
    intDelay = floor(d);
    frac = d - intDelay;

    if (d == 0) % When there are 0 samples of delay
        % y is based on input "x"

        y(n, 1) = (1 - frac) * x(n, 1) + frac * buffer(1,1);

    else % Greater than 0 samples of delay
        % Interpolate between delayed sample "in the past"

        y(n, 1) = (1 - frac) * buffer(intDelay, 1) ...
            + frac * buffer(intDelay + 1, 1);


    end


    buffer = [x(n, 1); buffer(1:end-1, 1)];

    % Increase delay time
    d = d + 0.5;

end

plot(t, in);
hold on;
time = [0: length(y) - 1] * Ts;
time = time(:);
plot(time, y);
hold off;
xlabel('Time (sec.)');
ylabel('Amplitude');
legend('Input', 'Output');





