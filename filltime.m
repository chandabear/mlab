function [dataout] = filltime(data, timeind, period, beg, fin)

% Function to fill missing timestamps in matrix data. Assumes data is
% relatively 'well behaved' and has a regular periodicity with gaps.  Fills
% gaps with NaN and recreates missing timestamp(s).

% Arguements
% 1 - data: matrix of data, including timestamp, assumes column order
% 2 - timeind: index of timestamp within matrix data
% 3 - period: user specified period of the data (1 sec, 30 min, etc). If no
% value is provided, then the default find the median period based on data.
% 4 - beg: starting timestamp, otherwise default uses first time
% 5 - fin: ending timestamp, otherwise default uses last time

if nargin == 3
    beg = data(1,timeind);
    fin = data(end,timeind);
end

if nargin == 2
    period = nanmedian(diff(data(:,timeind)));
end

% fill beginning period if needed with NaN
if (data(1,timeind)-beg) > period;
    data = insertrows(data, nan, 0);
    data(1,timeind) = beg;
end

% fill closing period if needed with NaN
if (fin-data(end,timeind)) > period;
    data = insertrows(data, nan, size(data,1));
    data(end,timeind) = fin;
end

% find indicies of missing timestamps
dummytime = data(:,timeind);
ind = (find(diff(dummytime) > period));
ind = flipud(ind);

datafill = data;
for i = 1:numel(ind)
    num_rows_to_add = round([dummytime(ind(i)+1) - dummytime(ind(i))]/period)-1;
    num_cols = size(datafill,2);
    datafill = insertrows(datafill, nan(num_rows_to_add,num_cols), ind(i));
    
    datafill(ind(i)+1:ind(i)+num_rows_to_add,timeind) = datafill(ind(i),timeind)+period : period : datafill(ind(i),timeind)+period*(num_rows_to_add);
    
end

dataout = datafill;