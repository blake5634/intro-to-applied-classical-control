function getkikd()
Kd = input("Click and enter Kd value:");

c = (Kd*(s-z1)*(s-z2)/s);
c1 = coeff(Kd*(s-z1)*(s-z2));

Kp = c1(2);
Ki = c1(1);

disp(c)

printf("Kp = %f,  Ki = %f, Kd = %f\n", Kp, Ki, Kd)



endfunction
