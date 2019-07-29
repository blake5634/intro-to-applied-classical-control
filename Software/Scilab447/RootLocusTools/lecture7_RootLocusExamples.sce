//  Lecture - Chapt 7 Root Locus
//   examples 7.1, 7.2

xdel(winsid()) // close all figures
clear          // delete all variables

s=%s
j=%i

//             K
//  ----------------------
//     (s+1)(s+2)(s+3)

K = 1
n = (s+4)*(s+5)
p1= -1+3*j
p2 = p1'


d = real((s-p1)*(s-p2))

syst = syslin('c', K*n/d)

evans(syst)

a = get("current_axes")
a.data_bounds = [-10, 5, -10, 10]
a.grid = [1,1]
