// fit OS data
funcprot(0)

// function to fit a polynomial (from scilab help)
function cf =polyfit(x,y,n)  // n = polynomial degree
    A = ones(length(x), n+1)
    for i=1:n
        A(:,i+1) = x(:).^i   // powers of x
    end
    cf = lsq(A,y(:)) // least squares
endfunction

// Data from lookup table
// Percent Overshoot
x = [0.01, 0.02, 0.05, 0.10]
// Angle Theta
y = [  34,   39,   46,   54] // deg
y = y *2*%pi/360.0  // radians

n=6
cf = polyfit(x,y,n) // cubic polynomial fit to lookup table

t = (.005:0.01:0.105)';  // plotting range for graph
A = ones(length(t), n+1)  //
for i=1:n
    A(:,i+1) = t.^i  // generate t^n for evaluating polynomial
end

plot(x,y,'r*')  // plot lookup table as red stars
plot(t,A*cf)  // A*cf multiplies coefficients times powers of t

title("Angle (rad) vs. Percent overshoot")
a = gca()
a.x_label.text = 'Overshoot'
a.y_label.text = 'Angle relative to negative real axis (rad)'
disp(cf)

