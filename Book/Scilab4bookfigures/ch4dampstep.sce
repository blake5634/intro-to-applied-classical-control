// 2nd order step responses w/ different zetas
// Chapter 4     23-July-12

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');
j = %i; e = %e;
exec('boderad.sci', -1)


we = -1.5:0.01:1.0;
w = (10^we)/(2*%pi);

dt   =    0.1;
tmax =    100;

t = 0:dt:tmax;

wn = 0.5;

zeta = [  0.05, 0.1, 0.25, 0.5, 0.75, 0.99];


for i = 1: length(zeta)
    
theta = acos(zeta(i));

p1 = -wn*cos(theta) + j * wn * sin(theta);
p2 = conj(p1); 

sys =  syslin('c', 25 / real((s-p1)*(s-p2))) ;

if(i==1) sys2 = sys;
 else  sys2 = [sys2 ; sys];
 end
 
 
end

boderad(sys2,w);
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