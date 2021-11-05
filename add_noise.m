function [Y,NOISE] = add_noise(X,SNR)
%Noise function
% X is the pure signal, SNR is the required signal-to-noise ratio (dB), Y is the noisy signal, and NOISE is the noise superimposed on the signal
NOISE=randn(size(X));
NOISE=NOISE-mean(NOISE);
signal_power = 1/length(X)*sum(X.*X);
noise_variance = signal_power / ( 10^(SNR/10) );
NOISE=sqrt(noise_variance)/std(NOISE)*NOISE;
Y=X+NOISE;
end