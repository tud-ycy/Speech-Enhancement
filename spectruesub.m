function [spectruesub_enspeech] = spectruesub(testsignal)
% Spectral subtraction function
% testsignal is a noisy speech signal
% spectruesub_enspeech is the signal after spectral subtraction processing
testsignal=testsignal';
%-------------------------------Parameter definition---------------------------------
frame_len=256; %Frame Length
step_len=0.5*frame_len; %The step size during framing, which is equivalent to 50% overlap
wav_length=length(testsignal);
R = step_len;
L = frame_len; 
f = (wav_length-mod(wav_length,frame_len))/frame_len;
k = 2*f-1; % Number of frames
h = sqrt(1/101.3434)*hamming(256)'; % The reason why the Hanning window is multiplied by the coefficient is to make it compound the requirements£»
testsignal = testsignal(1:f*L);  % ´øNoisy speech and pure speech length are aligned
% signal= signal(1:f*L);
win = zeros(1,f*L); % Set initial value£»
spectruesub_enspeech = zeros(1,f*L);       
%-------------------------------Framing-------------------------------------
for r = 1:k 
    y = testsignal(1+(r-1)*R:L+(r-1)*R); % Take half of the overlap between noisy speech frames£»
    y = y.*h; % Window processing for each frame obtained£»
    w = fft(y); % Fourier transform for each frame£»
    Y(1+(r-1)*L:r*L) = w(1:L); % Put the Fourier transform value in Y£»
end
%-------------------------------Estimated noise-----------------------------------
   NOISE= stationary_noise_evaluate(Y,L,k); %Noise minimum tracking algorithm
%-------------------------------Spectral subtraction-------------------------------------
for     t = 1:k     
         X = abs(Y).^2;   
         S = X(1+(t-1)*L:t*L)-NOISE(1+(t-1)*L:t*L); % Noisy speech power spectrum minus noise power spectrum£»
         S = sqrt(S);
         A = Y(1+(t-1)*L:t*L)./abs(Y(1+(t-1)*L:t*L)); % Noisy phase£»
         S = S.*A; % Because the human ear has no obvious perception of phase, the phase information of noisy speech is used for recovery.£»
         s = ifft(S);   
         s = real(s); % Real part£»
         spectruesub_enspeech(1+(t-1)*L/2:L+(t-1)*L/2) = spectruesub_enspeech(1+(t-1)*L/2:L+(t-1)*L/2)+s; % Concatenating and adding in the real domain£»
         win(1+(t-1)*L/2:L+(t-1)*L/2) = win(1+(t-1)*L/2:L+(t-1)*L/2)+h; % Window overlap£»
end
spectruesub_enspeech = spectruesub_enspeech./win; % Voice with enhanced gain due to removal of windowing£»
spectruesub_enspeech=spectruesub_enspeech';
end