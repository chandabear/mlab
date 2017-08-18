function [r2,ypredict,p] = rSMA(x,y)

%[r2,ypredict,p] = rSMA(x,y)
% written July 14, 2017 by Stephen Chan (swchan@lbl.gov)
% performs reduced major axis regression (RMA) also known as SMA
%
% returns the R2 value for a polynomial fit between two vectors
% also returns modeled fit for given x values
% also returns vector from polyfit
% format: rsquared(x,y,n)
% where x and y are equal length vectors and
% where n is the order of the polynomial

ind = isnan(x) | isnan(y);

p(1,1) = nanstd(y)./nanstd(x);
p(1,2) = nanmean(y) - p(1,1)*nanmean(x);

ypredict = polyval(p,x);

r2m = corrcoef(y(~ind),ypredict(~ind)).^2;

r2 = r2m(2,1);