// EE447  Lecture 4       (24-Oct-2012)
//
// Scilab file to draw a FANCY Bode plots for CC poles

xdel(winsid())   // close ALL graphics windows
clear 
s = %s;

//  Wn is the "natural frequency," also is the magnitude of the two complex 
//     conjugate poles. 

Wn = 50* 2 *%pi;     //  this frequency is 50Hz (converted to rad/sec)

zeta = 0.01 ;         //  edit this and play around with damping ratio

//  
//   Set up the transfer function(s)
//
num = Wn*Wn;         //  this keeps the magnitude constant as we vary Wn
den = s^2 + 2*zeta*Wn*s + Wn^2;  // classic 2nd order characteristic poly. 

sys = syslin('c', num/den);    // now we convert it to a Scilab linear system 

f = [1:1:30 , 31:0.2:64 , 65:5:2000 ]; // put lots of detail around Wn

zeta = 1.0;
den1 = s^2 + 2*zeta*Wn*s + Wn^2;  // classic 2nd order characteristic poly. 
zeta = 0.75;
den2 = s^2 + 2*zeta*Wn*s + Wn^2;  // classic 2nd order characteristic poly. 
zeta = 0.4;
den3 = s^2 + 2*zeta*Wn*s + Wn^2;  // classic 2nd order characteristic poly. 
zeta = 0.1;
den4 = s^2 + 2*zeta*Wn*s + Wn^2;  // classic 2nd order characteristic poly. 
zeta = 0.05;
den5 = s^2 + 2*zeta*Wn*s + Wn^2;  // classic 2nd order characteristic poly. 
zeta = 0.01;
den6 = s^2 + 2*zeta*Wn*s + Wn^2;  // classic 2nd order characteristic poly.  


sys1 = syslin('c', num/den1);    // now we convert it to a Scilab linear system 
sys2 = syslin('c', num/den2);    // now we convert it to a Scilab linear system 
sys3 = syslin('c', num/den3);    // now we convert it to a Scilab linear system 
sys4 = syslin('c', num/den4);    // now we convert it to a Scilab linear system 
sys5 = syslin('c', num/den5);    // now we convert it to a Scilab linear system 
sys6 = syslin('c', num/den6);    // now we convert it to a Scilab linear system  

st = [sys1; sys2; sys3; sys4; sys5; sys6]

bode(st,f,"rad");      // make the Bode plot with a better frequency range

fontsize = 3;

title("Bode plot of 2nd order system")

xset("font",1,fontsize);
alphatext = ["$\zeta=0.01$"]; 
xstring( 55,20,alphatext);
xstring( 4,20, "$\omega_n=50Hz$");

alphatext = ["$\zeta=1.0$"]; 
xstring( 23,-25,alphatext);
