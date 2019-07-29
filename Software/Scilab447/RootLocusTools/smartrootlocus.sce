// smart root locus
 
clear ;
xdel(winsid());   // close all graphics windows which might be open
s=%s;
j=%i;

exec('evans447.sci',-1);  // load the better evans function

// EXAMPLE
// enter CPH here:
//numerator: (leave K out for computer root-locus)
n = real( s^4+36*s^3+673*s^2+5160*s+15300);
// denominator:
//d = real((s+0.30)*(s+1+j*3)*(s+1-j*3));
d =(s^5+68*s^4+1842*s^3+24830*s^2+166425*s+443250)

//  LOOP GAIN
// oltf = Open Loop Transfer Function (CPH(s))
oltf = syslin('c',n/d);

// Plotting Range (relative to pole/zero cluster size)
pscalex =  4;
pscaley =  2;

ctlz = [0,0]; // use these for PID control

/////////////////////////////////////////////////////////////
//   Root Locus only (define your system above this)
//
// get all the poles and zeros for plot scaling
//  "evans" should do this automatically but doesn't do well
features = cat(2,roots(oltf(3))',roots(oltf(2))')

// Use the plant poles to scale the RL (ignore pp)
x1 = pscalex * min(real(features));
//x2 = pscalex * max(real(roots(pltf(3))));
x2 = 5; // usually better than automatic


y1 = pscaley * min(imag(features));
y2 = pscaley * max(imag(features));
 

//  PLOT ROOT LOCUS
evans447(oltf,1000)      //  "evans447" is slightly modified to eliminate 
                    //  the annoying legend box 
//
a1=get("current_axes");//get the handle of the newly created axesctl
a1.data_bounds=[x1,x2, y1,y2]; 
// plot the radial lines
sgrid;
 
// end!

 
