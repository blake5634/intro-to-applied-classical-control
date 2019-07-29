//EE447, ICP 7.9 root locus for manual PID design

clear all;
xdel(winsid());   // close all graphics windows which might be open
s=%s;
j=%i;

p= 26.7/((s+1)*(s+4));

// First try
z1 = -8+5*j;
z2 = -8-5*j;
 

Kd = 1.0;

pp = 200; //  we have to move this pole way out!!

c=Kd*pp*real((s-z1)*(s-z2)) / (s*((s+pp)));
//c = Kd/s;

sys = syslin('c',c*p);
evans(sys,100.0);
a1=get("current_axes");//get the handle of the newly created axesctl
a1.data_bounds=[-20,5, -20,20];
sgrid;