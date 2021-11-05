%%Three methods of speech enhancement
%******************************************************
% In the audioread function, you can set the read voice signal
% Change the value of SNR to change the added noise
%
[Input, Fs] = audioread('clean speech.wav');
[Noise, fs] = audioread('babble noise.wav');
Time = (0:1/Fs:(length(Input)-1)/Fs)';
%Take mono
Input = Input(:,1);
Noise = Noise(:,1);
L=length(Input);
Noise = Noise(1:L);
NoisyInput = Input+Noise;
SNR_original = snr(Input,Noise);
% SNR is the signal-to-noise ratio (dB) of adding noise and pure signal
% SNR=10;
% [NoisyInput,Noise] = add_noise(Input,SNR);%NoisyInput为加噪信号，Noise是噪声
%% Three methods for enhanced voice
[spectruesub_enspeech] = spectruesub(NoisyInput);
 [wiener_enspeech] = wienerfilter(NoisyInput);
 [Klaman_Output] = kalman(NoisyInput,Fs,Noise);
 
%% spectruesub draw
%Align the signal length
sig_len=length(spectruesub_enspeech);
NoisyInput=NoisyInput(1:sig_len);
Input=Input(1:sig_len);
wiener_enspeech=wiener_enspeech(1:sig_len);
Klaman_Output=Klaman_Output(1:sig_len);
Time = (0:1/Fs:(sig_len-1)/Fs)';
% Time= ((0:1/Fs:(sig_len)-1)/Fs)';
figure(1)
MAX_Am(1)=max(Input);
MAX_Am(2)=max(NoisyInput);
MAX_Am(3)=max(spectruesub_enspeech);
subplot(3,1,1);
plot(Time, Input)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('original signal')

subplot(3,1,2);
plot(Time, NoisyInput)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('signal with noise')

subplot(3,1,3);
plot(Time, spectruesub_enspeech)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('spectral abstraction')


%% spectruesub draw
% Time_wiener = (0:1/Fs:(length(wiener_enspeech)-1)/Fs)';
figure(2)
MAX_Am(1)=max(Input);
MAX_Am(2)=max(NoisyInput);
MAX_Am(3)=max(wiener_enspeech);
subplot(3,1,1);
plot(Time, Input)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('original signal')

subplot(3,1,2);
plot(Time, NoisyInput)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('signal with noise')

subplot(3,1,3);
plot(Time, wiener_enspeech)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('Wiener')

%% Kalman draw
figure(3)
MAX_Am(1)=max(Input);
MAX_Am(2)=max(NoisyInput);
MAX_Am(3)=max(Klaman_Output);
subplot(3,1,1);
plot(Time, Input)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('original signal')

subplot(3,1,2);
plot(Time, NoisyInput)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('signal with noise')

subplot(3,1,3);
plot(Time, Klaman_Output)
ylim([-max(MAX_Am),max(MAX_Am)]);
xlabel('Time')
ylabel('Amlitude')
title('Kalman')

%% Find the signal-to-noise ratio after speech noise reduction
SNR(1)=snr(Input,Input-spectruesub_enspeech);
SNR(2)=snr(Input,Input-wiener_enspeech);
SNR(3)=snr(Input,Input-Klaman_Output);

%% Spectrogram
frame_len=256; %Frame length
h = sqrt(1/101.3434)*hamming(256)';
step_len=0.5*frame_len;
figure(4)
subplot(3,1,1)
spectrogram(Input,256,128,256,fs,'yaxis');%Draw a spectrogram'yaxis' represents the frequency axis on the Y axis
xlabel('Time')
ylabel('Frenquency')
title('Clean speech')
subplot(3,1,2)
spectrogram(NoisyInput,256,128,256,fs,'yaxis');%Draw a spectrogram'yaxis' represents the frequency axis on the Y axis/
title('Noisy Speech')
subplot(3,1,3)
spectrogram(wiener_enspeech,256,128,256,fs,'yaxis');%Draw a spectrogram'yaxis' represents the frequency axis on the Y axis/
title('Wiener')






