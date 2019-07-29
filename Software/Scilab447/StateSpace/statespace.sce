//  State space example
//
clear 
// Toyota Camry (estimates)
Kt = 1.0E05    //Tire stiffness (vertical) N/m 
Ks = 2610      //Suspension Spring constant  N/m (2000-3000)
Bs = .8*1000   //Shock Absorber Ns/m
Mv = 1610/4.0   //Mass (1/4)  kg
Mw =  22.7      //Typical wheel and tire mass, kg

a = -(Kt+Ks)/Mw
b = -Bs/Mw
c = Ks/Mw
d = Bs/Mw

e = Ks/Mv
f = Bs/Mv
g = -Ks/Mv
h = -Bs/Mv

A = [0, 1, 0, 0 ;
     a, b, c, d ;
     0, 0, 0, 1 ;
     e, f, g, h]
     
B = [0,Kt/Mw,0,0 ]'

C = [1,0,0,0.]
//     0,0,1,0 ; ] 
     
D = zeros(4)

susp = syslin('c',A,B,C)  // D is optional
t=0:.005:3.0;
y = csim('step',t,susp)
scf(1)
plot(t,y)

scf(2)

// now we're going to plot 2D state space trajectory of step response
C = [1,0,0,0.;
     0,1, 0, 0]  // this 'C' matrix gives both X2 and Xdot2

susp = syslin('c',A,B,C)  // D is optional
y1 = csim('step',t,susp)

plot(y1(1,:),y1(2,:))


//   Now let's demonstrate conversion between SS and TF forms

tf = ss2tf(susp)(1)    //
