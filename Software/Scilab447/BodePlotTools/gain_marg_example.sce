//
// Scilab file to draw a FANCY Bode plots for CC poles


clear all;
s = %s;

G2num = 4E005
G2den =  ((s+1)*(s+31.6)*(s+100))

G2 = syslin('c', G2num/G2den)

f = [1:5:2000]

bode(G2,f,"rad")

gm = g_margin(G2)
pm = p_margin(G2)

