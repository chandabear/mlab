function [r2,ypredict,p] = rsquared(x,y,n)

%[r2,ypredict,p] = rsquared(x,y,n)
% returns the R2 value for a polynomial fit between two vectors
% also returns modeled fit for given x values
% also returns vector from polyfit
% format: rsquared(x,y,n)
% where x and y are equal length vectors and
% where n is the order of the polynomial

p = polyfit(x,y,n);

ypredict = polyval(p,x);

r2m = corrcoef(y,ypredict).^2;

r2 = r2m(2,1);