// 2nd order sinusoidal responses
// Chapter 4     17-July-12

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');
j = %i;

dt   =    0.1;
tmax =    200;

t = 0:dt:tmax;

w = 0.2 *2*%pi ;    //0.25 Hz

u = sin(w*t);

tz1 =  0.5*length(u);
tz2 = length(u);

//  uncomment for the "interrupted" sinusoid model
//for k= tz1:tz2 
//        //disp("t:", t, "u: ", u(k), " u/2  ", u(k)*0.5);
//        u(k) = u(k)*0.0;
//    end;

p1 = -0.05+j*.4;   p2 = conj(p1);

sys = syslin('c', 50 / ((s-p1)*(s-p2)));

y = csim(u, t, sys);

scf(1);
plot(t,y);
title('Response to sin(wt)u(t)')

scf(2)
plot(t,u)