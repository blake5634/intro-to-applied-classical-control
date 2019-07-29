// fit polynomial to the percent overshoot function
clear

xd = [0.01,0.02,0.05,0.10, 0.50, 1.0]  // % overshoot
yd = [34. , 39., 46., 54,85,  90]  // deg

xd = [0.01,0.02,0.05,0.10]  // % overshoot
yd = [34. , 39., 46., 54]  // deg

function cf = polyfit(x,y,n)
A = ones(length(x),n+1)
for i=1:n
    A(:,i+1) = x(:).^i
end
cf = lsq(A,y(:))
endfunction

vect = polyfit(xd,yd,2)

pp = poly(vect, 'r', 'coeff')

plot(xd,yd)
t = linspace(0.0, 0.2, 20)
plot(t, horner(pp,t))
