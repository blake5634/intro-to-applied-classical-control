// Non linearity example / disturbance
//  EE447   July 2012

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');
j = %i; e = %e;

x = 0:10;
K = 1.5;

f = K * x + 0.1*K*x.*x;
k2 = (0.9*max(f)/max(x));
fl = k2*x;
fnl = f-fl;

scf(1);
plot(x,f, x, fl, x, fnl);
title('Non linear spring.');
 
t = 0:0.01:10;
xt = 5.0+5*sin(2*t);

scf(2)
plot(t,xt);

fsnl = K*xt + 0.1*K*(xt.*xt); 

fsl = xt*k2;
fsnl2 =  K*xt + 0.1*K*(xt.*xt) - fsl;

scf(3) 
plot(t,fsnl, t,fsl, t, fsnl2);

title('force developed by nonlinear spring with sinusoidal input')