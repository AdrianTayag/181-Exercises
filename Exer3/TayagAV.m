%Program that generates the COPT from a given FOR table.

Data = xlsread('Generator FOR Data.xlsx');
matsize = size(Data);
elements = matsize(1,1);
FOR = [0];
CO = [0];
count = 1;

%Programmed for no Derated States.
for i = 2:(elements-1)
    if Data(i,1) == 0 
        FOR(count+1) = Data(i,2);
    elseif Data(i,2) ~= 0
        CO(count+1) = Data(i,1);
        count = count+1;
    end
end

%Generating Combinations.
matsize = size(CO);
elements = matsize(1,2);

%Step 1. (1-FOR)*P'(X) + FOR*(X-C)
P1 = [];
P1(999) = 1;
step = 1;
Cout = CO(step)+CO(step+1);
for i = 1:Cout
    C = CO(step+1);
    X = i;
    if X == 0
        X = 999;
    end
    Y = X-C;
    if Y <= 0
        Y = 999;
    end
    P1(X) = (1-FOR(1,2))*(P1(X)) + (FOR(1,2)*P1(Y));
end

%Step 2.
P2 = [];
P2(999) = 1;
step = step+1;
Cout = CO(step)+CO(step+1);
for i = 1:Cout
    C = CO(step+1);
    X = i;
    if X == 0
        X = 999;
    end
    Y = X-C;
    if Y <= 0
        Y = 999;
    end
    P2(X) = (1-FOR(1,2))*(P1(X)) + (FOR(1,2)*P1(Y));
end

%Step 3.
P3 = [];
P3(999) = 1;
step = step+1;
Cout = CO(step)+CO(step+1)+CO(step-1);
for i = 1:Cout
    C = CO(step+1);
    X = i;
    if X == 0
        X = 999;
    end
    Y = X-C;
    if Y <= 0
        Y = 999;
    end
    P3(X) = (1-FOR(1,2))*(P2(X)) + (FOR(1,2)*P2(Y));
end

%Compiling for writing to CSV.
row = nchoosek(size(CO),2);
COPT = zeros(row(2),2);
COPT(1,1) = 0;
COPT(1,2) = 1.0;
COPT(2,2) = P3(1);
row = 2;
for i = 1:Cout
    if P3(i+1) ~= P3(i)
        COPT(row,1) = i;
        COPT(row,2) = P3(i);
        row = row+1;
    end
end

%Writing to CSV.
xlswrite('Tayag_GeneratorCOPT.xlsx', COPT);