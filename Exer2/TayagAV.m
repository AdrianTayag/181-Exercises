%Program that solves for at most 6-Bus DC Load Flow problems.
Branch = xlsread('BranchData.xlsx'); %frombus, tobus, linereactance 
Bus = xlsread('BusData.xlsx'); %bus, pgen, pload
%Bus1 as slack bus, 100MVA as Sbase

%Getting Ybus
Ybus = zeros(6,6);
for i = 1:9
    fbus = Branch(i,1);
    tbus = Branch(i,2);
    X = Branch(i,3);
    if Ybus(fbus,tbus) == 0
        Ybus(fbus,fbus) = Ybus(fbus,fbus)-(X)^-1;
        Ybus(tbus,tbus) = Ybus(tbus,tbus)-(X)^-1;
        Ybus(fbus,tbus) = (X)^-1;
        Ybus(tbus,fbus) = (X)^-1;
    else
        Ybus(fbus,fbus) = Ybus(fbus,fbus)-(X)^-1;
        Ybus(tbus,tbus) = Ybus(tbus,tbus)-(X)^-1;
        Ybus(fbus,tbus) = Ybus(fbus,tbus)+(X)^-1;
        Ybus(tbus,fbus) = Ybus(tbus,fbus)+(X)^-1;
    end
end

%Getting Pbus, assume no shunt terms, bus1 as slack
Pbus = zeros(5,5);
for i = 1:5
    for j = 1:5
        Pbus(i,j) = Ybus(i+1,j+1);
    end
end
Pbus = -1*Pbus;

%Getting P values
power = zeros(5,1);
for i = 1:5
    power(i,1) = Bus(i+1,2) - Bus(i+1,3);
end

%Getting angle values
angles = Pbus\power;

%Getting power flows
flow = zeros(15,3);
count = 1;
for i = 1:6
    for j = i:5
        %fills up the combination of iterations
        flow(count,1) = i;
        flow(count,2) = j+1;
        %calculating for flows
        if i==1
            flow(count,3) = 100*Ybus(i,j+1)*(0-angles(j,1));
        else
            flow(count,3) = 100*Ybus(i,j+1)*(angles(i-1,1)-angles(j,1));
        end
        count = count+1;      
    end  
end

%sample scenario for iteration guide.
%flow(1,3) = Ybus(1,2)*(0-angles(1,1));
%flow(2,3) = Ybus(1,3)*(0-angles(2,1));
%...
% flow(6,3) = Ybus(2,3)*(angles(1,1)-angles(2,1));
% flow(7,3) = Ybus(2,4)*(angles(1,1)-angles(3,1));

%display results
flow
xlswrite('TayagAV.xlsx', flow); %From Bus, To Bus, PowerFlow(MW)
