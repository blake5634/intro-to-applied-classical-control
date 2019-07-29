// Step disturbance rejection
// Chapter 5     23-July-12

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');
j = %i; e = %e;

t = 0:0.001:1.;

y = 0.2 + 20*e^(-101*t);

plot(t,y);
title('Disturbance rejection response to step disturbance');