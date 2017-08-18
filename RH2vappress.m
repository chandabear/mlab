function [e] = RH2vappress(RH, T)

% convert relative humidity (percent) to vapor pressure (kPa)

% inputs:
% RH - relative humidity (percent)
% T - air temperature (oC)

% output:
% e - vapor pressure([kPa])

% first calculate saturation vapor pressure (Pa)
% formula via Bolton 1980
% https://www.rsmas.miami.edu/users/pzuidema/Bolton.pdf
es = 611.2.*exp(17.67.*T./(T+243.5));

% then, calculate vapor pressure (Pa) from RH
e = es.*RH/100;

% convert to kPa
e = e/1000;
