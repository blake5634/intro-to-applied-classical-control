// 447  optimized Root Locus Function  rl447.sce
//
//   BH   Nov 2016
//
//   BH  corrected POS line angle   Sept 2017
//
//  Args:
//       sys -  output of syslin('c', xxx)
//       rflag -  1 = ignore regularization pole when computing
//                       plotting scale
//                2 = ignore two highest mag features, etc.
//                0 = show all poles and zeros
//       TS = Settling time design spec (0 to skip)
//       POS = %Overshoot design spec (0 to skip)
//       kmax - max K value for Root Locus
// 

function rl447(sys,rflag,Ts, POS, kmax)
//    type "Hello from rl447"
    if (POS > 1.0) then 
        POS = POS - 1.0
    end
    
    select typeof(sys)
    case "rational" then
        [n,d] = sys(2:3)
        n = real(n)
        d = real(d)
    case "state-space" then
        [n,d] = sys(2:3)
        n = real(clean(n))
        d = real(clean(d))
    end
    
    // find proper scale for RL plot
    poles = roots(d)
    zers = roots(n)  // cant use word "zeros"!!
    
    f = zeros(50,1)
    i = 1
    jmax = 0
    s1 = size(poles)
    for ii = 1:s1(1)
        f(i) = abs(poles(ii))
        im = abs(imag(poles(ii)))
        if(im > jmax) then
            jmax = im
        end
        i = i+1
    end
    
    s1 = size(zers)
    for ii = 1:s1(1)
        f(i) = abs(zers(ii))
        im = abs(imag(zers(ii)))
        if(im > jmax) then
            jmax = im
        end
        i = i+1
    end
    
    f = gsort(f,'g','d')
    
    if(rflag > 0) then
     for ii = 1:rflag   //  ASSUMPTION:  reg poles are biggest!
            f(ii) = 0    // clear out regularization features
        end
    end
    
    f = gsort(f,'g','d')
    maxf = f(1)  // Maxf is biggest feature mag (>0))
    printf("Max feature mag: %8.2f\n",maxf)
    printf("Max imag part: %8.2f\n", jmax)
    ymarg = 1.5
    xmarg = 1.1
    xmin = xmarg * maxf *-1
    xmax = (xmarg-1.0) * maxf
    ymin = ymarg * jmax * -1
    if ymin > -1 then
        ymin = xmin/2
    end
    ymax = -1*ymin
    
    printf('xmin: %8.2f, xmax: %8.2f, ymin: %8.2f, ymax: %8.2f\n', xmin,xmax,ymin,ymax)
    evans447(n,d,kmax)
    
    
    a = gca()  // get current plotting axes pointer
    
    // Plot Real and Imaginary Axes
    plot([0,0],[1.2*ymin,1.2*ymax],'black')
    
  
    // Draw Performance Specs(!)
    //   Plot diagonals for Percent Overshoot
    theta = 0.0
    printf("POS: %f\n",POS)
    if(POS >= 0.00 & POS <= 0.40) then
        printf("Percent OS OK %f\n", POS)
        // here we have fit a polynomial to approximate the overshoot
        //   lookup table!
        thd = 30.906998 + 388.67403*POS - 1583.7937*POS^2  // deg
        th = 2*%pi*thd/360.00 // radians
        theta = %pi-th // actual plotting angle for line
        printf("theta: %f (%f deg)", theta, 360*theta/6.28)
        y = xmin*tan(theta)
        plot([0,xmin],[0,y],'m--')
        plot([0,xmin],[0,-y],'m--') 
    end
    
    //  Settling Time
    if(Ts >= 0) then
        sig = -4/Ts
        y = sig*tan(theta)*1.2
        plot([sig,sig],[-y,y],'m-.')  // Settling Time Spec
    end
    
    
    // set CORRECTED data bounds
    a.data_bounds = [xmin,ymin;xmax,ymax]
    a.grid = [1,1]
//    end
//    for ii = 1:i-1
//        printf("feature: %8.2f +j%8.2f \n",real(f(ii)), imag(f(ii)))
//    end
endfunction

//////////////////////////////////////////////////////////////////////////
//  Test

TEST = 0

if(TEST > 0) then
    s = %s
    n = (s+4)*(s+5)
    //d = (s+2)*(s+40+10*j)*(s+40-10*j)*(s+100+20*j)*(s+100-20*j)
    d = (s^2+6*s+13)*(s^2+10*s+41)*(s+10)
    n = real(n)
    d = real(d)
    sys = syslin('c', n/d)
    
    //   syst, rflg, TS, POS, Kmax
    rl447(sys,0,1.143,0.05,20000)
end
