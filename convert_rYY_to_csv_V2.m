function dat = convert_rYY_to_csv_V2(fname,nrows)

% converts HuskerFlux binary, high-frequency data files to ascii format
% version 2 - automatically determines # of columns based on a 4 byte num

% required inputs:
% fname = filename to be read 
% nrows = (OPTIONAL) number of rows in data; 
%   if not entered, default is 864000 (i.e. 1 day of 10 Hz data)
% returns matrix of data. 

nbytes = 4;         % an assumption

if nargin == 1      % if 1 input
    nrows = 864000; % for 1 day at 10 Hz
end

x = dir(fname);
fid = fopen(fname,'r');

% calculate ncols based on number of rows and bytes per number
ncols = x.bytes/nrows/nbytes;

count = [ncols nrows];
dat = fread(fid, count, 'float32');
dat = dat';
fclose(fid);