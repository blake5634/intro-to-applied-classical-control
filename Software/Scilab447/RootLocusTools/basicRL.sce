// Intro to scilab script files
//
//     Plot the Root locus of a closed loop system
//

clear ;           // the whole workspace
xdel(winsid());   // close all graphics windows which might be open
s=%s;             // define 's' as a variable
j=%i;             // j = sqrt(-1)

//  loop 
//plant
pn = (s+1)
p1 = -0.7+0.2*j
p2 = p1'
pd = (s+2)*(s-p1)*(s-p2)

z1 = -6+2*j
z2 = z1'

z1 = -1
z2 = -4

cn = (s-z1)*(s-z2)
cd = s

num = real(cn*pn)
den = real(cd*pd)

// open loop transfer function
cph = syslin('c',num,den)  // set up a continuous time linear system
evans(cph,50) 
a = gca()
a.grid= [2,2]
a.data_bounds=[-25,5, -10, 10]
