// EE447  Lecture 4       (24-Oct-2012)
//
// Scilab file to draw Bode plots for CC poles


clear all;
s = %s;

//  Wn is the "natural frequency," also is the magnitude of the two complex 
//     conjugate poles. 

Wn = 250;     //  this frequency is rad/sec

zeta = 0.01 ;         //  edit this and play around with damping ratio

//  
//   Set up the transfer function
//
num = Wn*Wn;         //  this keeps the magnitude constant as we vary Wn
den = s^2 + 2*zeta*Wn*s + Wn^2;  // classic 2nd order characteristic poly. 

sys = syslin('c', num/den);    // now we convert it to a Scilab linear system 

bode(sys,1.0, 1.0E04, "rad");      // make the Bode plot with a better frequency range
