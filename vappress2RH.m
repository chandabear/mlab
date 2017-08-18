function [RH] = vappress2RH(e, T)

% convert vapor pressure (kPa) to relative humidity (percent) 

% inputs:
% e - vapor pressure([kPa])
% T - air temperature (oC)

% output:
% RH - relative humidity (percent)

% first calculate saturation vapor pressure (Pa)
% formula via Bolton 1980
% https://www.rsmas.miami.edu/users/pzuidema/Bolton.pdf
es = 611.2.*exp(17.67.*T./(T+243.5));

% convert to kPa
es = es/1000;

% then, calculate RH
RH = e./es*100;