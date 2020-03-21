%Annual LOLE, LOEE, EENS, EIR
%COPT - CapOut, CapIn, IndProb, CumuProb
%Load Prof - Day, Time, Load

COPT = xlsread('COPT_PL.xlsx');
COPTsize = size(COPT);
LP = xlsread('LoadProfile_PL.csv');
LPsize = size(LP);

%Calculating for LOLE. LOLE = sum[Pi(Ci-Li)]
LOLE = 0;
Totalcap = COPT(1,1);

for i = 1:LPsize(1)
    for y = 1:COPTsize(1)
        X = Totalcap - LP(i,3);
        if X >= COPT(y,1)
            LOLE = LOLE + COPT(y-1,4);
            break;
        end
    end
end


%Calculating for LOEE. LOEE = sum(EiPi / Etotal)
Etotal = 0;
EENS = 0;
Peak = 0;

%Search for peak load & Etotal for the dataset
for i = 1:LPsize(1)
    if LP(i,3) > Peak
        Peak = LP(i,3);      
    end
    Etotal = Etotal + LP(i,3);
end

%Determining starting point for Energy Curtailed computation
for i = 1:COPTsize(1)
    if COPT(i,2) > Peak
        maxcap = i-1;
        break;
    end
end

Ei = 0;
EENS = 0;
curtailed = 0;
%Iteration for LOEE computation
for i = 1:maxcap
    for y = 1:LPsize(1)
        if (LP(y,3) - COPT(i,2)) < 0
            curtailed = 0;
        else
            curtailed = LP(y,3) - COPT(i,2);
        end
        Ei = Ei + curtailed;
    end
    EENS = EENS + (Ei*COPT(i,3));
    Ei = 0;
end

LOEE = EENS / Etotal;
EIR = 1-LOEE;

Output = [LOLE, EENS, EIR];
%Writing to CSV.
xlswrite('Tayag_Exer2PL.xlsx', Output);
        