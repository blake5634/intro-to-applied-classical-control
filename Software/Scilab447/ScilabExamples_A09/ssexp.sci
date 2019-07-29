//Statespace Examples in Scilab
//

clear; 

j = sqrt(-1);

s=poly(0,'s');        // make a polynomial variable s


TF1 = 1/(s+2);

TF2 = 1/((s+2)*(s+5));

TF3 = 1/((s+2)*(s+5)*(s+10));



TF = (1)/((s+5)*(s+2)*(s+1+3*j)*(s+1-3*j)*(s+1.5+6*j)*(s+1.5-6*j))

M = [0 1 0 0 0 0 ;  
     0 0 1 0 0 0 ;
     0 0 0 1 0 0 ;
     0 0 0 0 1 0 ;
     0 0 0 0 0 1 ;
     -3825 -2742.5 -1670.5 -536.25 -99.25 -12  ]


t=0:0.025:5;

B = [0 0 0 0 0 1 ]';

[Ac,Bc,U,ind] = canon(M,B) ;         ///    convert to controllable cannonical form;

