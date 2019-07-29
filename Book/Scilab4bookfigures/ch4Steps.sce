// 2nd order responses
// Chapter 4     17-July-12

clear all; 
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
s = poly(0,'s');

Nr = 5
Nim = 4

e = %e;         // base of natural logs
 
wn = 0.1*2*%pi; 

function plot2ndorder(re, im, n)
wn = sqrt(re^2+im^2);
z  = -re / wn;
t = 0:0.1:100;
phi = %pi/4;      // some random phase shift
wd = wn*sqrt(1-z*z)  // damped natural frequency
y = 1.0 - e^(-1*z*wn*t) .* cos(wd*t+phi);

env1 = 1.0  +   e^(-1*z*wn*t);
env2 = 1.0  -   e^(-1*z*wn*t);

subplot(Nim,Nr,n)
//scf(n)
plot( t, y, t, env1, t, env2);
a = gca();
a.data_bounds = [0 100 -1 3]
endfunction


////////////////////////   Start of graphics loop

Re =  [-0.5, -.05, -.01, 0.01, 0.05 ];
Im =  [.5, .3, .15,    .05];

for(i=1:1:Nim)
    for(j=1:1:Nr)
       m = Nr*(i-1)+j;
       printf ("plotting: %4.2f + j%4.2f (%d)\n", Re(j), Im(i),m)
       plot2ndorder(Re(j), Im(i), m); 
       title(sprintf("pole: %4.2f + j%4.2f", Re(j), Im(i)));
    end;
end;
