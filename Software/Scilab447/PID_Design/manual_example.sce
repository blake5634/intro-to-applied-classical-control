// Some examples of 'manual' PID design
//    EE 447     Nov 2016
//

xdel(winsid()) // close all figures
clear

s=%s
j=%i

cd ('/home/blake/Dropbox/447/Homework/A')  // where I want to actually work

DIR = '/home/blake/Dropbox/447/Scilab447/RootLocusTools/'  //  customize to the place you store the scripts

exec(DIR+'evans447.sci',-1)
exec(DIR+'rl447.sce',-1)


// select a design example 
//EXAMPLE = 1        // Simple plant
//EXAMPLE = 1.1         // Simple Plant with PD control
//EXAMPLE = 2         //  more complicated plant
//EXAMPLE = 3          // 3 real poles and no zeros

EXAMPLE = 1.1

if(EXAMPLE == 1) then
    ////////  Plant model
    p1 = -2
    p2 = -2
    pln = real(1)
    pld = real((s-p1)*(s-p2))
    plant = syslin('c', pln/pld)
    
    //   Desired Performance Specs
    Tsd = 1
    POSd = 1.05
    
    //////  Controller
    // PID Control zeros
    z1 = -12
    z2 = -8
     
    // regularization pole
    pr = 15 * min([real(z1),real(z2)])
    // Make PID Controller 
    ctn = real((s-z1)* (s-z2)*(-pr))
    ctd = real(s*(s-pr))
    ctl = syslin('c', ctn/ctd)
    Kmax = 3000
end


if(EXAMPLE == 1.1) then
    ////////  Plant model
    p1 = -2
    p2 = -2
    pln = real(1)
    pld = real((s-p1)*(s-p2))
    plant = syslin('c', pln/pld)
    
    //   Desired Performance Specs
    Tsd = 1
    POSd = 0.05
    
    //////  Controller
    // PD Control zero
    z1 = -7 
     
    // regularization pole
    pr = 15 * -7
    // Make PD Controller 
    ctn = real((s-z1)*(-pr))
    ctd = real((s-pr))
    ctl = syslin('c', ctn/ctd)
    Kmax = 2000
end


if(EXAMPLE == 2) then
    ////////  Plant model
    p1 = -0.7+0.2*j
    p2 = -0.7-0.2*j
    pln = real((s-(-1))
    pld = real((s-(-2))*(s-p1)*(s-p2))
    plant = syslin('c', pln/pld)
    
    //   Desired Performance Specs
    Tsd = 1.333
    POSd = 0.10
    
    //////  Controller
    // PID Control zeros
    z1 = -6+2*j
    z2 = -6-2*j
    
    z1 = -1
    z2 = -4
    
    // regularization pole
    pr = 15 * min([real(z1),real(z2)])
    
    // Make PID Controller 
    ctn = real((s-z1)* (s-z2)*(-pr))
    ctd = real(s*(s-pr))
    ctl = syslin('c', ctn/ctd)
    Kmax = 10
end

if(EXAMPLE == 3) then
    ////////  Plant model
    p1 = -3+2*j
    p2 = -3-2*j
    p3 = -8
    pln = real(1000)
    pld = real((s-p3)*(s-p1)*(s-p2))
    plant = syslin('c', pln/pld)
    
    //   Desired Performance Specs
    Tsd = 2.0
    POSd = 0.20
    
    //////  Controller
    // PID Control zeros
    z1 = -10    
    z2 = -3
    
    // regularization pole
    pr = 8 * min([real(z1),real(z2)])
    
    // Make PID Controller 
    ctn = real((s-z1)* (s-z2)*(-pr))
    ctd = real(s*(s-pr))
    ctl = syslin('c', ctn/ctd)
    Kmax = 10
end
 

//// Plot RL with Specs
rl447(ctl*plant, 1, Tsd, POSd, Kmax)
a = gca()
a.grid=[1,1]
//   Adjust plot ranges if nesc and set K value

if(EXAMPLE == 1) then
    a.data_bounds=[-140, -40 ; 20, 40]
    K=20
end
if(EXAMPLE == 1.1) then
    a.data_bounds=[-25, -20 ; 5, 20]
    K=16
end
if(EXAMPLE == 2) then
    a.data_bounds=[-8 -5 ;1 5]
    K=20
end 
if(EXAMPLE == 3) then
    a.data_bounds=[-100 -50 ;1 50]
    K=0.009
end 

//ctl2 = syslin('c', K*ctn*pln, 1+K*ctd*pld)
cltf = K*ctl*plant /. 1

tmax = 8.0   // step function plot range
t = 0:0.05:tmax;

scf(2)
Y = csim('step', t, cltf)
plot(t,Y)

//  Draw Ts spec and 2% window
plot([Tsd, Tsd], [0, 2], 'r--')
if(POSd > 1.0) then        //   get rid of 1.05 eg.
    POSd = POSd - 1.0
end

wx = [0,tmax]
wy1 = [1.0+POSd, 1.0+POSd]
wy2 = [1.0-POSd, 1.0-POSd]
plot(wx, wy1, 'g')
plot(wx, wy2, 'g')
