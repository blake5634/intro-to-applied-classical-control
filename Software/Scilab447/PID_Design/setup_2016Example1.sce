// setup.sce

//   Set up key variables for control design search.
// 
//   Example 1
// 
//

clear all;
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
DIR = '/home/blake/Dropbox/447/Scilab447/PID_Design/'  //  customize to the place you store the

cd(DIR)

// correct this for your own computer (may be higher or lower!)
npermin = 1250;   //  how many step responses per min on this computer

/////////////////////
//  uncomment these lines to make time predictions more accurate

load('simrate_optigain','rate');
npermin = rate;
printf ("Found rate file: %d simulations per min.\n",npermin);



////////////////////////////////////////////////////////////////
//
//       plant definition
//
s=%s
j=%i

Htf = s/s;
H = syslin('c', Htf);

tmax = 3.5;  // seconds
dt = tmax/100;


// Plant Transfer Function
////////  Plant model    (Example 1)
    p1 = -2
    p2 = -2
    pln = real(1)
    pld = real((s-p1)*(s-p2))
    plant = syslin('c', pln/pld)

////  set this about 10 times higher than highest plant pole/zero
    pp = 15;  //  pole to rationalize PID controller

////////////////////////////   Desired Performance

tsd =   1.0;   // Desired Settling Time
pod =   1.05;   // Desired Percent Overshoot
ssed =  0.0;   // Desired Steady State Error

cu_max = 100.0;  //  Normalization value for control effort.

gmd = 20;   // desired gain margin

////////////////////////////   Search range and step

nvals = 20;  // number of gain values to try btwn kmax and kmin

//  Search region setting:   set K1-K3 for the "center" PID values

// Kp center value
Kp =8.3 ;

// KI center value
Ki = 7.6 ;

// Kd center value
Kd = 1.0 ;


K1=Kp;K2=Ki;K3=Kd  //  K1-K3 is notation used by optimization
//   "center values" are logarithmic midpoint of search range

scale_range = 1.25;   // how big a range to search.


tsearch=((nvals+1)^3)/npermin;
if(tsearch < 120) then
   printf("\n\nEstimated search time: %4.1f minutes\n", tsearch);
   else
   printf("\n\nEstimated search time: %4.1f hours\n", tsearch/60.0);
 end

// start the optimzation run automatically
exec('optigain7.sce',-1);


