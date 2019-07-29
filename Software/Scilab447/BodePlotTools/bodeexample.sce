// EE447 Bode plot\
//

s=%s;
clear all;

wn = 150;
z = 0.76;

den = s^2 + 2*z*wn*s + wn*wn;
num = wn*wn;

sys = syslin('c',  num/den);

bode(sys,"rad");
