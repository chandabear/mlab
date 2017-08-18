function [Err, Yhat, p] = rTLS(x, y)
% Orthogonal linear regression method in 2D for model: y = a + bx   
%
% Input parameters:
%  - x: input data block -- x: axis
%  - y: input data block -- y: axis
% Output parameters:
%  - Err: error - sum of orthogonal distances 
%  - Yhat: predicted y values. 
%  - p: vector of model parameters [b-slope, a-offset] 
% 
% Original Authors:
% Ivo Petras (ivo.petras@tuke.sk) 
% Dagmar Bednarova (dagmar.bednarova@tuke.sk)
% Date: 24/05/2006, 15/07/2009
%
% Modified by W. Stephen Chan 08/2017\
% added statement to ignore NaN

ind = isnan(x) | isnan(y);
x = x(~ind);
y = y(~ind);

kx=length(x);
ky=length(y);
if kx ~= ky
   disp('Incompatible X and Y data in function rTLS.m');
end

sy=sum(y)./ky;
sx=sum(x)./kx;
sxy=sum(x.*y);
sy2=sum(y.^2);
sx2=sum(x.^2);

B=0.5.*(((sy2-ky.*sy.^2)-(sx2-kx.*sx.^2))./(ky.*sx.*sy-sxy));

b1=-B+(B.^2+1).^0.5;
b2=-B-(B.^2+1).^0.5;

a1=sy-b1.*sx;
a2=sy-b2.*sx;

R=corrcoef(x,y);
if R(1,2) > 0 
    p=[b1 a1];
elseif R(1,2) < 0
    p=[b2 a2];
end
Yhat = x.*p(1) + p(2);
Xhat = ((y-p(2))./p(1));


alpha = atan(abs((Yhat-y)./(Xhat-x)));
d=abs(Xhat-x).*sin(alpha);

Err=sum(d.^2);
       
