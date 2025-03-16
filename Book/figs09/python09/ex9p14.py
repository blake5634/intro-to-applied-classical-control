import numpy as np
import control as ctl
import matplotlib.pyplot as plt

#
#    ECE 447  Book Chapt9
#

s = ctl.TransferFunction.s

# Plant
Pp0= -2.0
Pp1 = -0.7-0.2j
Pz1 = -1
# z2 = np.conj(z1)
Pp2 = np.conj(p1)
plant = ((s-z1)) / ((s+p0)*(s-p1)*(s-p2))

# controller first attempt zero placement
Cz1 = -6+2j
Cz2 = np.conj(Cz1)

# controller 2nd attempt for better targeting

Cz1 = -1
Cz2 = -4

#regularization pole
Prr = 10*np.real(Pp1)

ctl = ctl.tf()

ctl.root_locus_plot(G2)

plt.show()
