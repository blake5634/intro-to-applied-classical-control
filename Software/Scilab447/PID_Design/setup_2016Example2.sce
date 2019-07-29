// setup.sce

//   Set up key variables for control design search.
//
//  version: 27-Sept-2011
//

//   Final:
//
//[Overshoot =  1.10] Kp: 17.146  Ki: 14.289  Kd:  4.899
//Settling Time:  1.68  Overshoot:  9.9 percent  SSE:  0.001 gain margin: 10000.0 dB, Ctl Effort: 293.93877
//  Search boundary reached:  Kp min Ki min Kd max 
//

clear all;
xdel(winsid());   // close all graphics windows which might be open
funcprot(0);      // allow functions to be redefined without warnings.

// Customize this to where your scilab files are
DIR = '/home/blake/Dropbox/447/Scilab447/PID_Design/' 
 

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

p1 = -0.7+0.2*j
p2 = -0.7-0.2*j
np =  real((s+1))
dp =  real((s+2)*(s-p1)*(s-p2));
plant =   syslin('c', np/dp);

////  set this about 10 times higher than highest plant pole/zero
    pp = 60;  //  pole to rationalize PID controller

////////////////////////////   Desired Performance

tsd =   1.33;   // Desired Settling Time
pod =  1.10;   // Desired Percent Overshoot
ssed =  0.0;   // Desired Steady State Error

cu_max = 1500.0;  //  Normalization value for control effort.

gmd = 20;   // desired gain margin

////////////////////////////   Search range and step

nvals = 9;  // number of gain values to try btwn kmax and kmin

//  Search region setting:   set K1-K3 for the "center" PID values

// Kp center value
Kp = 21 ;

// KI center value
Ki = 17.5  ;

// Kd center value
Kd = 4;

K1=Kp;K2=Ki;K3=Kd  //  K1-K3 is notation used by optimization
//   "center values" are logarithmic midpoint of search range

scale_range = 1.5;    // how big a range to search.


tsearch=((nvals+1)^3)/npermin;
if(tsearch < 120) then
   printf("\n\nEstimated search time: %4.1f minutes\n", tsearch);
   else
   printf("\n\nEstimated search time: %4.1f hours\n", tsearch/60.0);
 end

// start the optimzation run automatically
exec('optigain7.sce',-1);


