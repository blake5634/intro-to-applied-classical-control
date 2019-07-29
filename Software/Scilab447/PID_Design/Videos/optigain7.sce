//optigain.sce
//
//   search for optimal PID gains
//
//      26-Nov-2011:   fix bug for unstable.
//
//      25-Sep-2013:   Remove all graphics for cloud use
//
//      15-Oct-2013:   Speed up stability check with roots!
//      14-Nov-2013:   Add gain/phase margins as a perf spec.
//      15-Nov-2013    Make it easier to add more perf specs
//         Aug-2016    Correct Control Effort TF (!)

exec('stepperf.sce');

t = 0:dt:tmax;

start_time = getdate("s");////////////////////////////////////////////////////////////
//
//      function which evaluates controller performance, PID version
//
//   ts - settling time
//   po -  % overshoot
//   ss - steady state error
//   cu - control effort
//   gm - gain margin
//   y  - unit step response (y(t))

function [ts, po, ss, cu, gm, y] = costPID(plant,Kp,Ki,Kd,pp)
    //define controller

    pctl = pp*(Kd*s^2 + Kp*s + Ki)/(s*(s+pp));
    ctl  = syslin('c',pctl);
    //
 //   sys = closed loop system TF
    sys = ctl*plant / (1+ctl*plant*H);
//    pause;
    loopgain = ctl*plant;
    [gm, f] = g_margin(loopgain); // New: get the gain margin
    if(gm > 10000) then gm = 10000;  // "inf" is a possible gm
        end
    ts = 0;
// faster way to check for instability!
// quick check for positive roots (unstable)
    syspoles = roots(sys(3));  // unpacks denominator from sys
//    pause;
    for i5=1:length(syspoles)
        if (real(syspoles(i5)) > 0) then
            ts = 999; po = 999; ss = 999 ; cu = 10^7; y = t;
        end
    end

    ctl_effort = ctl / (1+ctl*plant*H);  //  get actuator output effort
    if(ts == 0) then // we have a stable system
         y = csim(ones(t),t,sys);       // get closed loop outputs
         u = csim(ones(t),t,ctl_effort);
         ts = settletime(t,y);
         po = overshoot(t,y);
         ss = sse(t,y);
         cu = max(u);
    end
//    pause;
endfunction

/////////////////////////   Performance definition / Specs


// set up several weight schemes for performance

//   wts = weight on settling time
//   wos = weight on overshoot
//   wsse = weight on steady state error
//   wu  = weight on control effort
//    wm  = weight on gain margin

WTS =   1;  // index for settling time
WOS =   2;  // index for overshoot
WSSE =  3;  // index for Steady state error
WU   =  4;  // index for Control Effort
WM   =  5;  // index for gain margin

Np   = 5;   //  number of performance measures (above)
////////////////////  How many different weighting schemes you want:
Ns = 6;

/////////////////////////////////////  Name them and weight them

jj=1;
wnames(jj) = sprintf("Ts = %5.3f",tsd);
w(jj,WTS) = 1.0  ; w(jj,WOS) = 0.0;  w(jj,WSSE) = 0.0;  w(jj,WU) = 0.0; w(jj,WM) = 0.0;

//    Overshoot scheme
jj = 2;
wnames(jj) = sprintf("Overshoot = %5.2f",pod);
w(jj,WTS) = 0.0  ; w(jj,WOS) = 1.0;  w(jj,WSSE) = 0.0;  w(jj,WU) = 0.0; w(jj,WM) = 0.0;


//  Steady state error scheme
jj=3;
wnames(jj) = sprintf("SSE = %5.2f",ssed);
w(jj,WTS) = 0.0  ; w(jj,WOS) = 0.0;  w(jj,WSSE) = 1.0;  w(jj,WU) = 0.0; w(jj,WM) = 0.0;


// Control Effort Scheme
jj = 4;
wnames(jj) = sprintf("Control Effort Max = %5.2f", cu_max);
w(jj,WTS) = 0.0  ; w(jj,WOS) = 0.0;  w(jj,WSSE) = 0.0;  w(jj,WU) = 1.0; w(jj,WM) = 0.0;

// Gain Margin Scheme
jj=5
wnames(jj) = sprintf("Gain Margin = %4.0fdB", gmd);
w(jj,WTS) = 0.0  ; w(jj,WOS) = 0.0;  w(jj,WSSE) = 0.0;  w(jj,WU) = 0.0; w(jj,WM) = 1.0;

//  Balance of all the factors equally
jj= 6;
wnames(jj) = "Balanced";
w(jj,WTS) = 0.2  ; w(jj,WOS) = 0.2;  w(jj,WSSE) = 0.2;  w(jj,WU) = 0.2; w(jj,WM) = 0.2;

Ns = jj;   // number of weight schemes

for(i=1:Ns),          //  initialize search storage
    emin(i) = 99999999.99;
    Kpo(i) = -1;
    Kio(i) = -1;
    Kdo(i) = -1;
end;
for (i=1:Np)    // place to store perf errors
    e(i) = 0.0;
end


////////////////////////////   Parameter Searching   /////////////////////
//

//   Setup

scalef = sqrt(scale_range);

kmin  = K1/scalef ;  kmax = K1*scalef;
kimin = K2/scalef;   kimax = K2*scalef;
kdmin = K3/scalef;   kdmax = K3*scalef;


// Increments
dk  = (kmax-kmin)/nvals;
dki = (kimax-kimin)/nvals;
dkd = (kdmax-kdmin)/nvals;


//  this allows for PD, PI controllers etc
if(K1 == 0) then
    dk =1 
end
if(K2 == 0) then
    dki = 1
end
if(K3 == 0) then
    dkd = 1
end

iter = 1;
////////////////// Print progress bar
printf("|");
for i=1:nvals+1,
    printf("-");
    end
printf("|\n ");

maxpeak = 0.0;
///  Main Loop ////////////////////////////////   
for Kp = kmin:dk:kmax,
    printf(".");  // print progess under "progess bar"
    for Ki = kimin:dki:kimax,
        for Kd = kdmin:dkd:kdmax,
       //     printf("%4d: K: %3.1f %3.1f %3.1f  emin(1): %f ", iter, Kp, Ki, Kd, emin(1));
            iter = iter + 1;
            [ts1, po1, ss, cu,gm, y] = costPID(plant, Kp, Ki, Kd,pp);
            
      //      printf("%4d: K: %3.1f %3.1f %3.1f ", iter, Kp, Ki, Kd);
       // printf("%4d ",iter);
            if(ts1 > 900) then // 900 is an arbitrary flag to indicate unstable
            else  //  if the system was stable
                 if(max(y) > maxpeak) then  // figure out greatest amt of overshoot
                     maxpeak = max(y)       //   just for better plotting
                 end
                 // printf( " ts1: %f po1: %f   eTs: %f  ePO: %f ", ts1, po1, e1, e2);
                 // compute each performance error type
                 e(WTS)  = abs(ts1-tsd)/tsd;
                 e(WOS)  = abs(po1-pod)/pod;
                 e(WSSE) = abs( y(length(y))-1.0);
                 e(WU)   = cu/cu_max;
                 e(WM)   = abs(gm-gmd)/gmd;
                 //  compute each performance weighting scheme
                 for i = 1:Ns,
                    escore = w(i,:)*e;   // weight the error terms
                    if(escore < emin(i)) then // we've found something better
                        emin(i) = escore;
                        Kpo(i) = Kp; Kio(i) = Ki; Kdo(i) = Kd;
                        end
                 end
       //       printf(" em1: %f em2: %f em3: %f em4: %f", emin(1), emin(2), emin(3), emin(4));
            end;
       //    printf("\n");
       //     e = e1*e2;
       //     if(e < emin) then emin = e; Kpo = Kp; Kio = Ki; Kdo = Kd; end;

        end
    end
end

printf("\n\nOptimization search complete!\n\n");

/////////////////////////////////////////   Print Results
for i=1:Ns,
   if(Kpo(i) < .01 | Kio(i) < 0.01 | Kdo(i) < 0.01) then 
       printf("\n\n[%15s] Kp: %12.9f  Ki: %12.9f  Kd: %12.9f\n",wnames(i), Kpo(i),Kio(i),Kdo(i)); 
   else 
       printf("\n\n[%15s] Kp: %6.3f  Ki: %6.3f  Kd: %6.3f\n",wnames(i), Kpo(i),Kio(i),Kdo(i)); 
   end
   [ts1,po1, ss, cu, gm, ybest] = costPID(plant, Kpo(i), Kio(i), Kdo(i),pp);
   scf(i);
   plot(t,ybest); 
   title(wnames(i));
   // plot step response perf specs.
   plot([0,tmax],[1.0, 1.0],'r');         // step response goal
   plot([tsd,tsd],[0,maxpeak],'g');  // Ts goal
   a = gca()
//   printf("scaling to %f (maxpeak)\n",maxpeak)
   a.data_bounds=[0,0; tmax, maxpeak] 
   // report the performance
   printf("Settling Time: %5.2f  Overshoot: %4.1f percent  SSE: %6.3f gain margin: %4.1f dB, Ctl Effort: %7.5f\n", ts1, (po1-1)*100.0, ss , gm, cu);

   // warn if at edge of search space
   if(Kpo(i) == kmin | Kpo(i) == kmax | Kio(i) == kimin | Kio(i) == kimax | Kdo(i) == kdmin | Kdo(i) == kdmax) then
       printf("  Search boundary reached:  ");
       if  Kpo(i) == kmin  then printf("Kp min "); end
       if  Kpo(i) == kmax  then printf("Kp max "); end
       if  Kio(i) == kimin then printf("Ki min "); end
       if  Kio(i) == kimax then printf("Ki max "); end
       if  Kdo(i) == kdmin then printf("Kd min "); end
       if  Kdo(i) == kdmax then printf("Kd max "); end
       printf("\n");
   end
 end


//////////////////////////    Plot the  poles and  RL  of  the  balanced design
////
// pctl = pp*(Kdo(i)*s^2 + Kpo(i)*s + Kio(i))/(s*(s+pp));
// ctl  = syslin('c',pctl);
// ctl2 =  ctl/Kdo(i);     // normalize to  K=1;
// scf(i+1);
// evans(ctl2*plant, 20*Kdo(i))


// derive simulation speed from time measurements
end_time = getdate("s");
rate = (nvals+1)^3 / ((end_time-start_time)/60); // simulations per minute

 printf("\nSearch Time:  %3.1f minutes.  N = %d  (%8.1f sims/min)\n", (end_time-start_time)/60, (nvals+1)^3, rate );

// Record the simulation rate for accurate runtime predictions
save('simrate_optigain.sce','rate');

