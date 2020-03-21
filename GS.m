%Admittance Matrix
y11 = 100-100*1i;
y12 = -50+50*1i;
y13 = -50+50*1i;
y21 = -50+50*1i;
y22 = 100-99.99*1i;
y23 = -50+50*1i;
y31 = -50+50*1i;
y32 = -50+50*1i;
y33 = 100-99.99*1i;

%Known Values
v1 = 1.0;
v2 = 1.03;
d1 = 0;
p2 = 0.1;
q2 = 0.2;
p3 = -0.3;
q3 = -0.4;


%Flat Start Values
d2old = 0.0;
d3old = 0.0;
v3old = 1.0; 

v3 = 1.0;
n = 0;
iter = 0;

while n == 0
    v2rect = v2*(cos(d2old)+(sin(d2old)*1i));
    
    %PV Bus Iterations
    q2 = -imag(conj(v2rect)*((y21*v1)+(y22*v2rect)+(y23*v3)));
    d2 = angle(((conj(v2rect)\(p2-(q2*1i))) - (y21*v1 + y23*v3))/y22);
    
    %PQ Bus Iterations
    v3 = y33\((conj(v3)\(p3-(q3*1i)) - (y31*v1 + y32*v2rect)));
    
    %Current Solmatrix
    solmat = [d2, v3];
    
    %Tolerance
    tol = [d2-d2old, abs(v3-v3old)];
    
    %Prep for next iteration
    d2old = d2;
    v3old = v3;
    iter = iter +1;
    
    disp('# of Iterations:');
    disp(iter);
    disp('Tolerance');
    disp('d2 = ');
    disp(tol(1));
    disp('v3 = ');
    disp(tol(2));
    disp('Calculated Values');
    disp('d2 = ');
    disp(d2*180/pi);
    disp('d3 = ');
    disp(angle(v3)*180/pi);
    disp('v3 = ');
    disp(abs(v3));
    
    if (tol(1) < 10^(-4)) && (tol(2) < 10^(-4))
        n = 1;
    end    
end