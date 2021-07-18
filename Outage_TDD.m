%Simulation for Outage Probability for TDD scheme 
%Author : Dehit Trivedi,Neel Joshi, Prof. Yogesh Trivedi

%IMP The following code is for N = 2 
%for N = 3 change the change h3,h31,g3 and g31 to the commented part.

clc;clear all;

format long;
N = 20000;

f=sqrt(0.5);
index=1;
eta=0.99; 
rho=0.9;
eta2=eta*eta;
rho2=rho*rho;

SNR_T = 3;  % threshold SNR in dB
SNR_THR = 10^(SNR_T/10); % threshold snr in linar scale

for k = 1:4:40 
    k
    SNR_dB(index)=k;   % Tranmit SNR dB
    pt=10^(k/10);      % Transmit 
    pt=pt/2;
    
    h1=f*(randn(1,N)+1j*randn(1,N)); %channel b/w antenna 1 and receiver
    
    h2=f*(randn(1,N)+1j*randn(1,N));
    h3=f*(randn(1,N)+1j*randn(1,N));
    h4=h2;%f*(randn(1,N)+1j*randn(1,N));
    
    
    h11=eta*h1+sqrt(1-eta2)*f*(randn(1,N)+1j*randn(1,N)); %pair of antenna 2  
    h21=eta*h2+sqrt(1-eta2)*f*(randn(1,N)+1j*randn(1,N));
    h31=eta*h3+sqrt(1-eta2)*f*(randn(1,N)+1j*randn(1,N));
    h41=h21;%eta*h4+sqrt(1-eta2)*f*(randn(1,N)+1j*randn(1,N));
    
    %imperfect Channel received 
    g1=rho*h1+sqrt(1-rho2)*f*(randn(1,N)+1j*randn(1,N));
    g2=rho*h2+sqrt(1-rho2)*f*(randn(1,N)+1j*randn(1,N));
    g3=rho*h3+sqrt(1-rho2)*f*(randn(1,N)+1j*randn(1,N));
    g4=g2;%rho*h4+sqrt(1-rho2)*f*(randn(1,N)+1j*randn(1,N));
    
    g11=rho*h11+sqrt(1-rho2)*f*(randn(1,N)+1j*randn(1,N));
    g21=rho*h21+sqrt(1-rho2)*f*(randn(1,N)+1j*randn(1,N));
    g31=rho*h31+sqrt(1-rho2)*f*(randn(1,N)+1j*randn(1,N));
    g41=g21;%rho*h41+sqrt(1-rho2)*f*(randn(1,N)+1j*randn(1,N));
    
    [gg1,gg2,hh1,hh2] = antenna_select_TDD(g1,g11,g2,g21,g3,g31,g4,g41,h1,h11,h2,h21,h3,h31,h4,h41,N);
    
    absg1 = abs(gg1).^2;
    absg2 = abs(gg2).^2;
    
    num1=(conj(gg1).*hh1 +gg2.*conj(hh2)).*conj(conj(gg1).*hh1 +gg2.*conj(hh2))*pt;
    den1=(conj(gg1).*hh2 -gg2.*conj(hh1)).*conj(conj(gg2).*hh1 -gg2.*conj(hh1))*pt +gg1.*conj(gg1)+gg2.*conj(gg2);
    
    %num = ((norm((conj(gg1).*hh1)+(gg2.*conj(hh2))))^2)*pt;
    %den = ((norm((conj(gg1).*hh2)-(gg2.*conj(hh1))))^2)*pt+(absg1+absg2);
    snr = num1./den1;
    
    count=0;
    for kk = 1:N
        if snr(kk)<=SNR_THR
            count = count+1;
        end
    end
    Pout(index)=count/N;
    [SNR_dB(index) Pout(index)]
    index=index+1;  
    N=N+40000;
  
end
figure(2);
semilogy(SNR_dB, Pout,'k',LineWidth=1);
axis([1 18 0.0001 1]);
legend('N=3, \eta=0.99, \rho=1');
ylabel('Outage Probablity');
xlabel('SNR dB');
grid on
