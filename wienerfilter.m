function [wiener_enspeech] = wienerfilter(testsignal)
%Wiener filter function
testsignal=testsignal';
frame_len=256; 
step_len=0.5*frame_len; 
wav_length=length(testsignal);
R = step_len;
L = frame_len; 
f = (wav_length-mod(wav_length,frame_len))/frame_len;
k = 2*f-1; 
h = sqrt(1/101.3434)*hamming(256)'; 
% testsignal = testsignal(1:f*L);  
% signal= signal(1:f*L);  
win = zeros(1,f*L); % 设定初始值；
wiener_enspeech = zeros(1,f*L);                         
%-------------------------------Framing-------------------------------------
for r = 1:k 
    y = testsignal(1+(r-1)*R:L+(r-1)*R); 
    y = y.*h; 
    w = fft(y); 
    Y(1+(r-1)*L:r*L) = w(1:L);
end
%-------------------------------Estimated noise-----------------------------------
   NOISE= stationary_noise_evaluate(Y,L,k); 
 
 %-------------------------------Winner-------------------------------------
for t = 1:k     
    X = abs(Y).^2;   
    S=max((X(1+(t-1)*L:t*L)-NOISE(1+(t-1)*L:t*L)),0);%Set the part smaller than noise to zero, indicating that there is no signal here
    G_k=(X(1+(t-1)*L:t*L)-NOISE(1+(t-1)*L:t*L))./X(1+(t-1)*L:t*L); 
    S = sqrt(S);
    A1=G_k.*S;
    A = Y(1+(t-1)*L:t*L)./abs(Y(1+(t-1)*L:t*L)); ；
    S = A1.*A; 
    s = ifft(S);   
    s = real(s); 
    wiener_enspeech(1+(t-1)*L/2:L+(t-1)*L/2) = wiener_enspeech(1+(t-1)*L/2:L+(t-1)*L/2)+s; 
    win(1+(t-1)*L/2:L+(t-1)*L/2) = win(1+(t-1)*L/2:L+(t-1)*L/2)+h; 
end
wiener_enspeech = wiener_enspeech./win; 
wiener_enspeech=wiener_enspeech';
end