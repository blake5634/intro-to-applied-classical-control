// De-novo

xdel(winsid()) // close all figures
//clear          // delete all variables

s=%s
j=%i
//
//p1 = .4+j*80
//p2 = p1'
//
 
p1 = -200
wn = 5.0
z = cos(46*2*%pi/360)
n = wn*wn*(-p1)
//n = wn*wn

d = (s-p1)*(s^2 + 2*z*wn*s + wn*wn)
//d = s^2 + 2*z*wn*s + wn*wn

//  REQUIRED Step! if poles are complex
d = real(d)
//   (although the imag part is zero, you have to get rid of it! for csim())

G = syslin('c', n,d)

tmax = 10.00
dt = tmax / 500.0
t = [0: dt : tmax]

y = csim('step',t,G)

plot(t,y)

title('System Step Response')
//
//scf(2)
//
//bode(G,'rad')
//title('System Frequency Response')

