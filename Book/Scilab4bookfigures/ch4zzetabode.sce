// 2nd order zeros Bode  w/ different zetas
// Chapter 4     23-July-12

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');
j = %i; e = %e;
exec('boderad.sci', -1)


we = -1:0.01:3.0;   //  decade range for Bode plotting
w = (10^we)/(2*%pi);

dt   =    0.1;
tmax =    100;

t = 0:dt:tmax;

zeta = [  0.05, 0.1, 0.25, 0.5, 0.75, 0.99];


for i = 1: length(zeta)
    
theta = acos(zeta(i));

//   CC poles  

wn = 100; 
d = (s+10)*(s+30)*(s+500);
n = (s^2 + 2*zeta(i)*wn*s + wn^2);

sys =  syslin('c', n/d) ;

if(i==1) sys2 = sys;
 else  sys2 = [sys2 ; sys];
 end
 
 
end

boderad(sys2,w);
title('A system with CC poles');
//M = 50/wn^2;
//
//y = csim('step', t, sys);
//env1 = M*(1.0  +   e^(-1*z*wn*t));
//env2 = M*(1.0  -   e^(-1*z*wn*t));
//
//scf(1);
//plot(t,y,t,env1,t,env2);
//title('Step Response of Complex Conjugate 2nd Order Poles');
// 