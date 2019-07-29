// PID Analysis
//    Check properties of a PID design

function PID_analysis(plant, Kp,Ki, Kd,pp)
    xdel(winsid());   // close all graphics windows which might be open  
    s = %s;
    pctl = pp*(Kd*s^2 + Kp*s + Ki)/(s*(s+pp));
    
    ctl  = syslin('c',pctl);
    
     //
 //   sys = closed loop system TF
    sys = ctl*plant / (1+ctl*plant*H);
    //control effort
    ceff = ctl / (1+ctl*plant*H);
//    pause;
    loopgain = ctl*plant;
    [gm, f] = g_margin(loopgain); // New: get the gain margin
    
    if(gm > 10000) then gm = 10000;  // "inf" is a possible gm
        end
    ts = 0; 
    scf(1)   //                           Loop Gain Bode Plot 
    bode(loopgain)
    printf("gain Margin: %f", gm)
    tmax = 3.5
    t = 0:0.02:tmax;
    y = csim(ones(t),t,sys); 
    scf(2)   //                           Step Response
    plot(t,y)
    a = gcf()
    a.figure_name="Step Response"
    scf(3)    //                        Control Effort
    y = csim(ones(t), t, ceff)
    plot(t,y)
    f = gcf() 
    f.figure_name="Control Effort"
    r =roots(Kd*s^2 + Kp*s + Ki)
    printf("Controller Zeros:  %f %f", r(1),r(2))
    scf(4)    //                         Root Locus
    evans(loopgain)
    a = gca
    a.data_range = [-10,1, -5, 5]
endfunction
