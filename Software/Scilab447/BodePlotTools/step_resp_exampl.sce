// Example 5.1 for Chapter 5
//  step response to two real poles

// 
clear all

s=%s
e=%e
d = (s+3)*(s+10)
//
wn = 200
z = 0.05
d = s^2 + 2*z*wn*s + wn^2
n =10^4

n = (s+100)
d = (s+0.1)*(s+10^4)

//n = 1

G = syslin('c',n/d)

scf(1)

bode(G,'rad')
