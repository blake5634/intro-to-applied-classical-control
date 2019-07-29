// Step response performance analyzer
//
//  functions to compute and anlyze step response

 
// close all;

function y=step(t,sys) 
    y=csim('step',t,sys)
endfunction

function ss=sse(t,y)
    n=length(y);
    fval=y(n);
    ss = abs(1.0-fval);
endfunction


function ts=settletime(t,y)
    n=length(y);    
    fval=y(n);
    ymax = fval*1.02;
    ymin = fval/1.02;
    ts=0;
    while(n>0)
      //  printf("%6.3f %6.3f\n",t, y(n));
        if(y(n)<ymax & y(n)>ymin) then
            n = n -1;
        else
            ts=t(n);
            break;
        end; 
        end;
endfunction

function o = overshoot(t,y) 
    n=length(y);    
    fval=y(n);
    ymax = fval ; 
    while(n>0)
        if y(n) > ymax then ymax = y(n); end;
        n = n - 1;
    end;
    o = ymax / y(length(y)) ;
endfunction
