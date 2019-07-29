// First Root Locus Example
// Chapter 6    23-July-12

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');
j = %i; e = %e;

K = 1;

n = K*(s+4)*(s+5);
d = real((s+1+3*j)*(s+1-3*j));

sys = syslin('c',n/d);

evans(sys);
title("Root Locus Diagram");
a=get("current_axes");//get the handle of the newly created axes
a.data_bounds=[-10,5, -10, 10];
a.grid=[1,1];