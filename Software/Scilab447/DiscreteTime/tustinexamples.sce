// study some Tustin conversions


xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.

clear;
s=%s;j=%i;z=%z;
 

//scf(0)
//
//bode(Gcs)
//bode(Gz)
//
//pause; 
//   Now let's try a low-pass filter


f = 1.0;  // Hz


T0 = 1/1000;   // extreme sampling ! 
T1 = 1/200;  // some different sampling rates
T2 = 1/100;
T3 = 1/25;

// four different Tustin converters
m0 = (2/T0)*(z-1)/(z+1);
m1 = (2/T1)*(z-1)/(z+1);
m2 = (2/T2)*(z-1)/(z+1);
m3 = (2/T3)*(z-1)/(z+1);



z1 =  0.1*2*%pi;
p1 = .01*2*%pi;
p = f*2*%pi //  convert to rad/sec

Gf   = p^2*(s +z1)/((s +p1)*(s +p)^2);  //  two poles at p

Gfz0 = p^2*(m0+z1)/((m0+p1)*(m0+p)^2);  // discrete time version
Gfz1 = p^2*(m1+z1)/((m1+p1)*(m1+p)^2);  // discrete time version
Gfz2 = p^2*(m2+z1)/((m2+p1)*(m2+p)^2);  // discrete time version
Gfz3 = p^2*(m3+z1)/((m3+p1)*(m3+p)^2);  // discrete time version

Gfs   = syslin('c',Gf)
Gfz0s = syslin(T0,Gfz0);
Gfz1s = syslin(T1,Gfz1);
Gfz2s = syslin(T2,Gfz2);
Gfz3s = syslin(T3,Gfz3);

syslist = [Gfz0s; Gfz1s; Gfz2s; Gfz3s]

f = logspace(-3, 2, 100);

scf(0)
bode(Gfs,f);  // contin time system.
scf(1)
bode(syslist,f);  // discrete time  systems

//
//bode(Gfs,f);
//
//bode(Gfz1s,f);
//bode(Gfz2s,f);
//bode(Gfz3s,f);




