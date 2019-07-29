//EE447, ICP 7.8 root locus for manual PID design

clear all;
xdel(winsid());   // close all graphics windows which might be open
s=%s;
j=%i;

p=100*(s+0.1) / (s^2+3.5*s+4.0);
//p=100 / (s^2+3.5*s+4.0);

// First try
z1 = -70.0;
z2 = -100.0;
Kd = 1.0;

pp = -250; //  we have to move this pole way out!!

c=Kd*pp^2*(s-z1)*(s-z2) / (s*((s-pp)^2));
//c = Kd/s;

sys = syslin('c',c*p);
evans(sys,100.0);
a1=get("current_axes");//get the handle of the newly created axesctl
a1.data_bounds=[-200,10, -100,100];
sgrid;