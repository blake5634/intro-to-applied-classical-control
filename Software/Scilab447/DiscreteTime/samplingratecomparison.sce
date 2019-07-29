//   EE447
// 
//   Discretization with different sampling rates
//     Dec-2013
//


xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.

clear;
s=%s;j=%i;z=%z;

//////////////////////////////////////////////////////////
//  Instructions: 
//     Run this with different values of T (line 24)
//  T = 1/Fsamp;
//  T = 1/10000;   // 10x higher than highest "feature"
//  T =  1/1000;   //  Fsamp = highest feature
//  T =   1/100;   //  Fsamp WAY below the highest feature


// Set the sampling rate here
T = 1/10.00;


//  Compare the Continuous Time vs. the Discrete Time versions
//    For what range of frequencies is the DT version a good copy??
//


// set up a system to compare
//  highest feature = 1000Hz
//  we'll keep this system constant

//  Continuous Time version
wnz = 500;   zt = .5;
nz = s^2 + 2*zt*wnz*s + wnz*wnz;
//
wnp = 1000;  zp = 0.1;
np = s^2 + 2*zp*wnp*s + wnp*wnp;

n =     100*(s+10)*nz;
d =    (s+1)*(s+200)*np ;

Gs = syslin('c', n/d)

//  Now create the set up the same
//  Discrete Time System using Tustin's method

m = (2/T)*(z-1)/(z+1);
 
nz = m^2 + 2*zt*wnz*m + wnz*wnz;
// 
np = m^2 + 2*zp*wnp*m + wnp*wnp;

n =     100*(m+10)*nz;
d =    (m+1)*(m+200)*np ;
 

Gz = syslin(T, n/d);



///////////////////////  Bode Plotting

fmin = 0.001;
Df = (1/(2*T))/fmin;  // up to the nyquist rate
npts = 1000;
df = exp(log(Df)/npts);

f(1) = fmin;
for i=1:(npts-1);
  f(i+1) = f(i) * (df) 
end
f_d = f';
f_l = logspace(-3,3,npts);

x1 = 0.001;   x2 = 10^3;
y1 = -50;     y2 = 10;

//slist = [Gs; Gz];

bode(Gs,f_l);
str = sprintf("Continuous Time System (fsamp = %5.1f)",1/T);
title(str)
a=get("current_axes");//get the handle of the newly created axes
a.data_bounds=[x1,y1 ; x2,y2]; 


scf(1)
bode(Gz,f_l); 
str = sprintf("Discrete Time System (fsamp = %5.1f)",1/T);
title(str);
a=get("current_axes");//get the handle of the newly created axes
a.data_bounds=[x1,y1 ; x2,y2]; 

