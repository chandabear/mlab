function [ dat, Fname ] = unpackGHG( fname )
%unpackGHG - takes LICOR GHG file and returns *.data file
% INPUTS:
%   fname - full file name and path of GHG file
% OUTPUTS:
%   dat - matrix of contents of *.data file
%   Fname - file name of *.data file

[p,n,e] = fileparts(fname);
unzip(fullfile(p, [n e]));
dat = dlmread([n '.data'],'\t',8,1);
delete([n '*.*']);
    
Fname = n;
end

