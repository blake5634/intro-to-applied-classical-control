// Closed Loop poles
// Chapter 5     23-July-12

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');
j = %i; e = %e;


K = 0;
p = s^3+6*s^2+11*s+6+K ;


for(K=0:.1 :1)
  printf ("K=%3.1f ",K); 
  p = s^3+6*s^2+11*s+6+K ;
  a=roots(p);
  disp(a');
end


for(K=2:2 :10)
  printf ("K=%3.1f ",K); 
  p = s^3+6*s^2+11*s+6+K ;
  a=roots(p);
  disp(a');
end

for(K=10:10 :100)
  printf ("K=%3.1f ",K); 
  p = s^3+6*s^2+11*s+6+K ;
  a=roots(p);
  disp(a');
end

