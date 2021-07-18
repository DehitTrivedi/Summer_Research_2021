% 2X1 simple STBC 
% eta=0.5, rho=1
clc;
clear all;
format long;
N=10000;
f=sqrt(0.5);
index=1;
eta=0.5;  %correlation between between two antennas (single antenna pair)
rho=1;  %correlation coefficient

eta2=eta*eta;
rho2=rho*rho;

for kk=1:2:25
    xa=10^(kk/10);
    p=1/sqrt(xa);
    snr(index)=kk;
    xa=xa/2;
    
    mu=sqrt(xa/(xa+1));
    bera(index)=0.25*(2-3*mu+mu^3);
     
    %data to be transmited
    x1=randi([0 1],1,N);
    x2=randi([0 1],1,N);
    
    %BPSK modulation
    u1=2*x1-1;              
    u2=2*x2-1;

    %correlated channels
    h1=f*(randn(1,N)+j*randn(1,N));%
    h11=eta*h1+sqrt(1-eta2)*f*(randn(1,N)+j*randn(1,N));

    %effect of imperfect CSI at the receiver
    g1=rho*h1+sqrt(1-rho2)*f*(randn(1,N)+j*randn(1,N));
    g11=rho*h11+sqrt(1-rho2)*f*(randn(1,N)+j*randn(1,N));

    %AWGN noise
    n1=f*(randn(1,N)+j*randn(1,N)); %noise at time instance 1
    n2=f*(randn(1,N)+j*randn(1,N)); %noise at time instance 2

    %received symbols at two consecutyive instants using Alamouti scheme
    y1=f* (h1.*u1 + h11.*u2) + p*n1;
    y2=f* (-h1.*conj(u2) + h11.*conj(u1)) + p*n2;
    
    %decision variables
    t1=conj(g1).*y1+g11.*conj(y2);
    t2=conj(g11).*y1-g1.*conj(y2);
       
    %Detection rule and decision
    v1=(sign(real(t1))+1)/2;
    v2=(sign(real(t2))+1)/2;
            
    error1=xor(x1,v1);
    error2=xor(x2,v2);
    error=sum(error1)+sum(error2);
   
    bers(index)=error/(2*N);
    N=N+40000;
    [snr(index) bera(index) bers(index)]
    index=index+1;
end
figure(6);
semilogy(snr,bera,snr,bers,'k',LineWidth = 1);
title('STBC');
legend('Analytical','N=1, \rho = 1 ');
xlabel('SNR dB');
ylabel('BER'); 