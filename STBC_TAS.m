%STBC with TAS, 
%FDD-->antenna selection using imperfact CSI at transmitter
%TDD-->antenna selection using perfact CSI at transmitter
% eta=0, rho=1
%keep h3=h2=h1 and h31=h21=h11---->for all three pairs channel is assumed to be same
%                                  with nullified eefect of antenna selection

clc;
clear;
format long;
N=10000;
f=sqrt(0.5);
index=1;
eta=0.5; %array of 3 random correlation coefficient between three antenna pairs
              % change it to for now-->rho=0.8
              % 2nd case: different correlation
rho=0.6; %CSI at receiver

eta2=eta*eta;
rho2=rho*rho;

for kk=1:2:21
    xa=10^(kk/10);
    p=1/sqrt(xa);
    snr(index)=kk;
    xa=xa/2;
    
    mu=sqrt(xa/(xa+1));
    bera(index)=0.25*(2-3*mu+mu^3); %analytical expresssion
    
    h1=f*(randn(1,N)+j*randn(1,N)); %channel b/w antenna 1 and receiver
%     h2=h1;
%     h3=h1;
     h2=f*(randn(1,N)+j*randn(1,N));
     h3=f*(randn(1,N)+j*randn(1,N));
    
    h11=eta*h1+sqrt(1-eta2)*f*(randn(1,N)+j*randn(1,N)); %pair of antenna 2 
%    h21=h11;
%    h31=h11;
    h21=eta*h2+sqrt(1-eta2)*f*(randn(1,N)+j*randn(1,N));
    h31=eta*h3+sqrt(1-eta2)*f*(randn(1,N)+j*randn(1,N));
    
    
    %imperfect Channel estimated  
    g1=rho*h1+sqrt(1-rho2)*f*(randn(1,N)+j*randn(1,N));
    g2=rho*h2+sqrt(1-rho2)*f*(randn(1,N)+j*randn(1,N));
    g3=rho*h3+sqrt(1-rho2)*f*(randn(1,N)+j*randn(1,N));
    g11=rho*h11+sqrt(1-rho2)*f*(randn(1,N)+j*randn(1,N));
    g21=rho*h21+sqrt(1-rho2)*f*(randn(1,N)+j*randn(1,N));
    g31=rho*h31+sqrt(1-rho2)*f*(randn(1,N)+j*randn(1,N));
    
    n1=f* (randn(1,N)+j*randn(1,N)); %two different noise for two instances
    n2=f* (randn(1,N)+j*randn(1,N));
    
    x1=randi([0 1],1,N);
    x2=randi([0 1],1,N);
    
    u1=2*x1-1;
    u2=2*x2-1;

   for m=1:N
       
%------------------------FDD----------------------------------------
       a=g1(m)*conj(g1(m))+g11(m)*conj(g11(m)); % |g1^2|+|g11^2|
       a=[a;g2(m)*conj(g2(m))+g21(m)*conj(g21(m))];% |g1^2|+|g11^2|
       a=[a;g3(m)*conj(g3(m))+g31(m)*conj(g31(m))];% |g1^2|+|g11^2|

%------------------------TDD------------------------------------------

%        a=h1(m)*conj(h1(m))+h11(m)*conj(h11(m)); % |h1^2|+|h11^2|
%        a=[a;h2(m)*conj(h2(m))+h21(m)*conj(h21(m))];% |h1^2|+|h11^2|
%        a=[a;h3(m)*conj(h3(m))+h31(m)*conj(h31(m))];% |h1^2|+|h11^2|
       
       MAX=a(1);
       in=1;
       for i=1:2
           if MAX<a(i)
               MAX=a(i);
               in=i;
           end
       end
       
       if in==1
           selected_h1(m)=h1(m);
           selected_h2(m)=h11(m);   
           selected_g1(m)=g1(m);
           selected_g2(m)=g11(m);       
       end
       
       if in==2
           selected_h1(m)=h2(m);
           selected_h2(m)=h21(m);
           selected_g1(m)=g2(m);
           selected_g2(m)=g21(m);
       end
        
       if in==3
           selected_h1(m)=h3(m);
           selected_h2(m)=h31(m);
           selected_g1(m)=g3(m);
           selected_g2(m)=g31(m);
       end
   end
    
   y1=f* (selected_h1.*u1 + selected_h2.*u2) + p*n1;%received symbols
   y2=f* (-selected_h1.*conj(u2) + selected_h2.*conj(u1)) + p*n2;
           
   t1=conj(selected_g1).*y1+selected_g2.*conj(y2);%decision variables
   t2=conj(selected_g2).*y1-selected_g1.*conj(y2);
            
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
figure(2);
semilogy(snr,bers,'k',LineWidth=1);
legend('N=2, \rho = 0.6');
xlabel('SNR dB');
ylabel('BER'); 