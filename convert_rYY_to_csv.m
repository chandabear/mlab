function dat = convert_rYY_to_csv(fname, ncols, nrows)

% converts HuskerFlux binary, high-frequency data files to ascii format
% required inputs:
% fname = filename to be read 
% ncols = number of columns in data
% nrows = number of rows in data; 864000 for 1 day of 10 Hz data.
% returns matrix of data. 

fid = fopen(fname,'r');
% read data
count = [ncols nrows];
dat = fread(fid, count, 'float32');
dat = dat';
fclose(fid);