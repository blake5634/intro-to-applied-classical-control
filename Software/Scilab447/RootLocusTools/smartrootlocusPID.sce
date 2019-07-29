// smart root locus
 
clear ;
xdel(winsid());   // close all graphics windows which might be open
s=%s;
j=%i;

exec('evans447.sci',-1);  // load the better evans function

// PLANT
n1 = 10^4;
d1 = real((s+15)*(s+1+j*8)*(s+1-j*8));
pltf = syslin('c',  n1/d1);

// PID CONTROLLER ZEROS
z1 = -2+8.5*j; z2 = z1';

////// CONTROLLER POLE
// (this is req'd because order of numerator must be >= order of denominator.)

pp = 150; // pick frequency about 10x greater than biggest pole

/// PID
n2 = pp*real((s-z1)*(s-z2));
d2 = s*(s+pp);

//  LOOP GAIN
// oltf = Open Loop Transfer Function (CPH(s))
oltf = syslin('c',n1*n2/(d1*d2));
 

// Plotting Range
pscalex = 1.2;
pscaley = 2.0

// Use the plant poles to scale the RL (ignore pp)
x1 = pscalex * min(real(roots(pltf(3))));
//x2 = pscalex * max(real(roots(pltf(3))));
x2 = 5;


y1 = pscaley * min(imag([roots(pltf(3))',z1, z2]));
y2 = pscaley * max(imag([roots(pltf(3))',z1, z2]));
 

//
//////////////// >>   try PD ctl only  (1 zero only, no pole at origin) 
//
//z1 = -0.02;
//n2 = pp*(s-z1);
//d2 = (s+pp)

//  PLOT ROOT LOCUS
evans447(oltf, 10)
 
//
a1=get("current_axes");//get the handle of the newly created axesctl
a1.data_bounds=[x1,x2, y1,y2]; 
// plot the radial lines
sgrid;

// Use the K value and zeros to get  KP, KI
exec('getkikd.sci',-1)

 
