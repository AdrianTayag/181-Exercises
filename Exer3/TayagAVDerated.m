%Program that generates the COPT from a given FOR table.

%Gathering data from excel file.
Data = xlsread('Generator FOR Data.xlsx');
matsize = size(Data);
elements = matsize(1,1);
FORtable = [];
count = 1;

%Initializing variables.
gen = Data(end-1,1);
row = 1;
column = 1;
totalcap = 0;
cap = 0;

%Preparing FOR table for iteration
for i = 1:matsize(1)-2
    CapOut = gen - Data(end-i,1);
    FORtable(row,column) = CapOut;
    column = column + 1;
    FORtable(row,column) = Data(end-i,2);
    column = column + 1;
    if Data(end-i,1) == 0
        column = 1;
        gen = Data(end-(i+1),1);
        row = row+1;
    end
end

%Determining the total number of iterations per step.
FORtablesize = size(FORtable);
row = FORtablesize(1,1);
column = FORtablesize(1,2);
capx = 0;
for i = 1:row
    cap = 0;
    for j = 1:column
        if FORtable(i,j) > cap
            cap = FORtable(i,j);
        end
    end
    totalcap = totalcap + cap;
end

%Iterating the probabilities using the general formula.
P = zeros(FORtablesize(1,1),totalcap);
for i = 1:row
    cap = 0;
    for j = 1:column
        if FORtable(i,j) > cap
            cap = FORtable(i,j);
        end
    end
    capx = capx + cap;
    for x = 1:capx
        for y = 1:2:column
            Q = x - FORtable(i,y);
            if Q <=0
                prob = 1;
            elseif i == 1
                prob = 0;
            else
                prob = P(i-1,Q);
            end
            P(i,x) = P(i,x) + (FORtable(i,y+1)*prob);
        end
    end
end

%Compiling for writing to CSV.
comb = nchoosek(row+1,2);
COPT = zeros(comb,2);
COPT(1,1) = 0;
COPT(1,2) = 1.0;
COPT(2,2) = P(row,1);
count = 2;
for i = 1:totalcap
    if i == totalcap
        COPT(count,1) = i;
        COPT(count,2) = P(row,i);
        break;
    end
    if P(row,i+1) ~= P(row,i)
        COPT(count,1) = i;
        COPT(count,2) = P(row,i);
        count = count+1;
    end
end

%Writing to CSV.
xlswrite('Tayag_GeneratorCOPT.xlsx', COPT);
