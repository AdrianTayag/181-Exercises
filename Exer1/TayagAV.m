%Error: every line should be multiplied by peak load

%Reads and stores the data
data1 = readtable('data1.xlsx', 'Range', 'B1:C25');
data2 = readtable('data2.xlsx', 'Range', 'B1:C25');
data3 = readtable('data3.xlsx', 'Range', 'B1:C25');
%conversion from imported table into array to apply mathematical operation
d1 = table2array(data1);
d2 = table2array(data2);
d3 = table2array(data3);
data = zeros(24, 3);

%Iteration for storing data into PULoad and Price
for i = 1:24
  PULoad(i,1) = d1(i);
  PULoad(i,2) = d1(i);
  PULoad(i,3) = d3(i);
  Price(i,1) = d1(i+24);
  Price(i,2) = d2(i+24);
  Price(i,3) = d3(i+24);
end

%iteration of data into an array of hourly electricity cost
for x = 1:24
  data(x,1) = d1(x,1) * d1(x,2);
  data(x,2) = d2(x,1) * d2(x,2);
  data(x,3) = d3(x,1) * d3(x,2);
end

%converting back from array into table for output file
d = array2table(data);
filename = 'outputdata.xlsx';
writetable(d, filename, 'Sheet', 1, 'Range', 'A1');
