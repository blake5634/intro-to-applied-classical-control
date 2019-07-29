// smart root locus
//  New: improved Kmax algorithm
//  B. Hannaford EE447    Nov '13

//  Revision 1 - bug fixes   21-Nov-13
 
clear ;
xdel(winsid());   // close all graphics windows which might be open
s=%s;     j=%i;

exec('evans447.sci',-1);  // load the better evans function

AUTOK = 1;       // 1 = new auto K-range algorithm, 0 = manual, -1 = old evans alg.
epsilon = 0.001;  // how far from zeros to evaluate K 
manKmax = 5.0;    // manual K range

//////////////// (EXAMPLE PROBLEMS) /////////////////////

// enter CPH here:
//( in the numerator, leave K out for computer root-locus)


// example problem
d = s^2*(s+3.6)
n = (s+0.4)

// example problem
n = (s+2)^2
d = (s^2+4)*((s+5)^2)

// more examples
//  Three zero-sets for the same denominator
n = real( s^4+36*s^3+673*s^2+5160*s+15300);
//n = (s+3)*(s+10);
//n = real((s+10+10*j)*(s+10-10*j));
// denominator:
d = (s+5)^2*real((s+0.30)*(s+1+j*3)*(s+1-j*3));
//d =(s^5+68*s^4+1842*s^3+24830*s^2+166425*s+443250)

// (Swarthmore example 5)
n = s^2+2*s+2
d = s*(s^4+9*s^3+33*s^2+51*s+26)

// crazy example !
n = real((s+5+10*j)*(s+5-10*j))
d = s*(s+10)*real((s+5+5*j)*(s+5-5*j)*(s+2+8*j)*(s+2-8*j))



/////// ( enter your problem below)  /////////////// 

np = 200;
dp = (s+5)*(s+10);
nc = real((s+22+j*4)*(s+22-j*4))
dc = s;

n = nc*np;
d = dc*dp;

//(only the last one counts!)


///////////////////////   Your performance Specs
PLOTSPECS = 1;       // set to 0 to NOT plot the specs

Ts = 0.75;
POS = 1.05;    //  5% overshoot
wn  = 20;     // wn

sigma_st = log(0.02)/Ts;

// source: wikipedia: "Overshoot_(signal)"
a = log(POS-1)^2;
zeta_d = sqrt(a/(%pi^2+a));
theta = acos(zeta_d);



////////////// (may tweak these scale factors for aesthetics) //////
// Plotting Range (relative to pole/zero cluster size)
pscalex =  4;
pscaley =  8; 


/////////////////////////////////////////////////////////////
//   Root Locus only (define your system above this)
//
// get all the poles and zeros for plot scaling
//  "evans" should do this automatically but doesn't do well

////////////////////////////////////////////////////////
//  LOOP GAIN
// oltf = Open Loop Transfer Function (CPH(s))
oltf = syslin('c',n/d);

pole_list = roots(oltf(3));
zero_list = roots(oltf(2));
 
features = cat(2,roots(oltf(3))',roots(oltf(2))')

// Use the plant poles to scale the RL (ignore pp)
x1 = pscalex * min(real(features));
//x2 = pscalex * max(real(roots(pltf(3))));

// right boundary of RL plot
x2 = -0.1*x1; // usually better than automatic

y2 = pscaley * max(imag(features));
y1 = -y2;

if(y2 == 0) then
    y2 = 1; y1 = -y2;
end

printf("x1-2: %f %f y1-2: %f %f\n", x1,x2,y1,y2)
 
// r = size scale for pole-zero cluster
r = max(abs(y2-y1),abs(x2-x1));
printf("r factor: %f\n",r);

ndiff = degree(d)-degree(n);  // ndiff = np-nz

//  PLOT ROOT LOCUS

if(AUTOK < 0) then          //  use the old scilab evans K range algorithm
evans447(oltf)
else 
    if (AUTOK == 0) then    // set Kmax manually
    evans447(oltf, manKmax)      //  "evans447" is slightly modified to eliminate 
                    //  the annoying legend box 
//////////////////////////////////////////////////////  auto-K
else   // new auto k-range algorithm
// separate tricks for a few cases
  Kmax = 0;
  //  No zeros
  if(degree(n)==0) then  // case of no zeros
      // first asymptote angle (any will do)
      th = 3.14159/ndiff;
      // find a point outside the pole-zero cluster
      // first get real-axis asymptote
      sigma_a = (sum(pole_list)-sum(zero_list))/ndiff;
      // now find a point out on the asymptote 
      s1 = sigma_a + 10*r*cos(th) + j*10*r*sin(th); // 10x farther out
      CPHs = abs(horner(n,s1)/horner(d,s1)); // horner = eval polynomial
      Kmax = 1/CPHs; // apply magnitude condition
  else if (degree(n) > 0) then  // we have at least one zero
          for(i=1:length(zero_list)) do  // for each zero
              if(abs(imag(zero_list(i))) < r/100) then // 'REAL' zero
                   // check to the right:
                   rcount = 0; // how many poles/zeros to the right
                   for(j=1:length(features)) do
                       if(real(features(j)) > real(zero_list(i))) then
                           rcount = rcount + 1;
                       end
                       if(modulo(rcount,2)==1) then   // RL is RIGHT of zero
                          s1 = zero_list(i) + epsilon*r;
                       else                           // RL is to LEFT of zero
                          s1 = zero_list(i) - epsilon*r;
                       end 
                   end
                else   // we have a COMPLEX zero
                     s1 = zero_list(i) + epsilon*r; // go a little away
                end
                CPHs = abs(horner(n,s1)/horner(d,s1)); // horner = evaluate polynom
                if (1/CPHs > Kmax) then Kmax = 1/CPHs;
                  end
              end
       end // of zeros list
  end 
  printf("Kmax: %f \n",Kmax)
  evans447(oltf, Kmax);
end   
//

//  plot the performance regions

// Ts:
xv = [sigma_st; sigma_st]
yv = [y1; y2] ;
xsegs(xv,yv,1);
// %OS
xv = [0, 0; r*cos(%pi-theta),  r*cos(%pi-theta)]
yv = [0, 0; r*sin(%pi-theta), -r*sin(%pi-theta)]
xsegs(xv,yv,[1 2]);

a1=get("current_axes");//get the handle of the newly created axes
a1.data_bounds=[x1,y1 ; x2,y2]; 
// plot the radial lines
sgrid;
 
// end!

 
