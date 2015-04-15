function [r2,ypredict,p] = rsquared_v2(x,y,n)

%[r2,ypredict,p] = rsquared(x,y,n)
% updated on 23 April 2014 to now ignore NaN values
% returns the R2 value for a polynomial fit between two vectors
% also returns modeled fit for given x values
% also returns vector from polyfit
% format: rsquared(x,y,n)
% where x and y are equal length vectors and
% where n is the order of the polynomial

ind = isnan(x) | isnan(y);

p = polyfit(x(~ind),y(~ind),n);

ypredict = polyval(p,x);

r2m = corrcoef(y(~ind),ypredict(~ind)).^2;

r2 = r2m(2,1);