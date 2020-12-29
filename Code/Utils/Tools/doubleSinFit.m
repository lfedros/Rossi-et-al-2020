function doubleSin = doubleSinFit(pars, x)

[k ori dir sigma] = vecdeal(pars); 
 

% doubleSin  = k +  ori*sin(2*x +pi/2)+ dir*sin( x);

doubleSin  = k +  ori*sin(2*x +pi/2)+ dir*gaussian([pi/2, 1, 0, sigma], x);



end