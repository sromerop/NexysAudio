% [data, fs, Nbits] = wavread('haha.wav');
% [data, fs, Nbits] = audioread('haha.wav');
[data, fs] = audioread('haha.wav');
file = fopen('sample_in.dat', 'w');
fprintf(file, '%d\n', round(data.*127));