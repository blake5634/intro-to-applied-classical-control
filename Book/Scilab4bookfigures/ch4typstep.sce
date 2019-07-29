// 2nd order 'typical' step responses
// Chapter 4     17-July-12

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');
j = %i; e = %e;

dt   =    0.1;
tmax =    100;

t = 0:dt:tmax;

p1 = -0.05+j*.4;   p2 = conj(p1);

wn = norm(p1);
z  = -real(p1)/wn;

sys = syslin('c', 50 / ((s-p1)*(s-p2)));

M = 50/wn^2;

y = csim('step', t, sys);
env1 = M*(1.0  +   e^(-1*z*wn*t));
env2 = M*(1.0  -   e^(-1*z*wn*t));

scf(1);
plot(t,y,t,env1,t,env2);
title('Step Response of Complex Conjugate 2nd Order Poles');
 