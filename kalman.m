function [Output] = kalman(NoisyInput,Fs,Noise)
%initial
B=1200; 
p=12;    % The maximum number of iterations of the autoregressive algorithm is 12
G=zeros(p,1);
G(p)=1;
F=zeros(p);
H=G';

Qv=var(NoisyInput(1:2000));  %Qv solution

voice_kalman=NoisyInput;  %Initialize the sound

flag=floor(length(NoisyInput)/B);  %Calculate the number of windows

for i=0:flag-1
    x_n=zeros(p,1);           %initializationx(n|n)
    x_n_minus=zeros(p,1);     %initializationx(n|n-1)
    p_n=zeros(p);             %initializationp(n|n)
    p_n_minus=zeros(p);       %initializationp(n|n-1)
    
  
    if i==0
      A=lpc(NoisyInput(1+B*i:B*(i+1)),p); 
    else
      A=lpc(voice_kalman(1+B*(i-1):B*i),p);  
    end
   

    for k=1:p-1
      F(p,p+1-k)=-1*A(k+1);
      F(k,k+1)=1; 
    end
    F(p,1)=-1*A(p+1);
    

    Qw=0.00001;
    
  
    for j=1:B
            x_n_minus=F*x_n;
            p_n_minus=F*p_n*F'+G*Qw*G';
            
            %Kalman gain
            K=p_n_minus*H'*(Qv+H*p_n_minus*H').^(-1);
            
            p_n=p_n_minus-K*H*p_n_minus;
            x_n=x_n_minus+K*[NoisyInput(i*B+j)-H*x_n_minus];
            
            voice_kalman(i*B+j)=H*x_n;
    end
end
Output = voice_kalman;
end

