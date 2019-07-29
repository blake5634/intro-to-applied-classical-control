//  linearization examples for 447 book
//

clear all;
funcprot(0);


function y=f1(x)
    y = 0.4*x^2  -0.1*x^3 + 3.0*sin(x);
endfunction

function y=f1dot(x)
    y = 0.8*x  -0.3*x^2 + 3.0*cos(x);
endfunction

function y=f1a(x)
    y = 36.84-12.72*(x+6);
endfunction
function y=f1b(x)
    y = 2.824+2.121*(x-1);
endfunction




x = -10:0.2:10;

plot(x,f1(x))
