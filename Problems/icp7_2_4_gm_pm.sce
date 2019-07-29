//  EE447 ICP 7.2.4
//   Compute gain and phase margins.

clear all;
s = poly(0, 's');
K =25; 
c = K / (s+10) ;
p = (500*(s+1)) / ((s+0.1)*(s+25)*(s+20)) ; 
ctl   = syslin('c', c);
plant = syslin('c', p);
h     = syslin('c', s/s);
lg = ctl*plant*h;    //  CPH(s)

show_margins(lg);
gm = g_margin(lg);
pm = p_margin(lg);

printf("K = %6.1f\n",K);
printf("Phase Margin: %6.1f (deg)\n",pm);
printf("Gain  Margin: %6.1f (dB) \n",gm);