%Antenna Selesction function TDD
%Author : Dehit Trivedi, Neel Joshi 

function [selected_g1,selected_g2,selected_h1,selected_h2] = antenna_select_TDD(g1,g11,g2,g21,g3,g31,g4,g41,h1,h11,h2,h21,h3,h31,h4,h41,N);
    
    for m=1:N
       
       a=h1(m)*conj(h1(m))+h11(m)*conj(h11(m)); % |g1^2|+|g11^2|
       a=[a;h2(m)*conj(h2(m))+h21(m)*conj(h21(m))];% |g1^2|+|g11^2|
       a=[a;h3(m)*conj(h3(m))+h31(m)*conj(h31(m))];% |g1^2|+|g11^2|
       a=[a;h4(m)*conj(h4(m))+h41(m)*conj(h41(m))];
       
       MAX=a(1);
       in=1;
       for i=1:3
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
       
       if in==4
           selected_h1(m)=h4(m);
           selected_h2(m)=h41(m);   
           selected_g1(m)=g4(m);
           selected_g2(m)=g41(m);       
       end
   end
end 