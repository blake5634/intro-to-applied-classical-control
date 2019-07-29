// setup.sce

//   Set up key variables for control design search.
//
//  version: 27-Sept-2011
//

//   Final: (exa 1.1 PI controller)
//// 
////  (Note Balanced and Ts got same result)
//[       Balanced] Kp:  5.087054649  Ki:  5.031152949  Kd:  0.000000000
//Settling Time:  1.37  Overshoot:  1.7 percent  SSE:  0.027 gain margin: 22.8 dB, Ctl Effort: 5.87087
//  Search boundary reached:  Kd min Kd max 
//
//
//
//[     Ts = 1.000] Kp:  5.087054649  Ki:  5.031152949  Kd:  0.000000000
//Settling Time:  1.37  Overshoot:  1.7 percent  SSE:  0.027 gain margin: 22.8 dB, Ctl Effort: 5.87087
//  Search boundary reached:  Kd min Kd max 

clear all;
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.
DIR = '/home/blake/Dropbox/447/Scilab447/PID_Design/'  //  customize to the place you store the

cd(DIR)

// correct this for your own computer (may be higher or lower!)
npermin = 1250;   //  how many step responses per min on this computer

/////////////////////
//  uncomment these lines to make time predictions more accurate

// load('simrate_optigain2','rate');
// npermin = rate;
// printf ("Found rate file: %d simulations per min.\n",npermin);



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
    p1 = -2+j*3
    p2 = -2-3*j
    pln = real(1)
    pld = real((s-p1)*(s-p2))
    plant = syslin('c', pln/pld)

////  set this about 10 times higher than highest plant pole/zero
    pp = 20;  //  pole to rationalize PID controller

////////////////////////////   Desired Performance

tsd =   1.0;   // Desired Settling Time
pod =  1.05;   // Desired Percent Overshoot
ssed =  0.0;   // Desired Steady State Error

cu_max = 10.0;  //  Normalization value for control effort.

gmd = 20;   // desired gain margin

////////////////////////////   Search range and step

nvals = 20;  // number of gain values to try btwn kmax and kmin

//  Search region setting:   set K1-K3 for the "center" PID values

// Kp center value
Kp = 1.6;

// KI center value
Ki = 17  ;

// Kd center value
Kd = .44;

K1=Kp;K2=Ki;K3=Kd  //  K1-K3 is notation used by optimization
//   "center values" are logarithmic midpoint of search range

scale_range = 1.5;   // how big a range to search.


tsearch=((nvals+1)^3)/npermin;
if(tsearch < 120) then
   printf("\n\nEstimated search time: %4.1f minutes\n", tsearch);
   else
   printf("\n\nEstimated search time: %4.1f hours\n", tsearch/60.0);
 end

// start the optimzation run automatically
exec('optigain7.sce',-1);


