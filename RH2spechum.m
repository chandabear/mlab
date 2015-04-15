function [q] = RH2spechum(RH, T, P)

% convert relative humidity (percent) to specific humidity (ratio of mass
% mixing ratio of water vapor to mass mixing ratio of air)

% inputs:
% RH - relative humidity (percent)
% T - air temperature (oC)
% P - pressure (kPa)

% output:
% q - specifiic humidity ([])

% first calculate saturation vapor pressure (Pa)
% formula via Bolton 1980
% https://www.rsmas.miami.edu/users/pzuidema/Bolton.pdf
es = 611.2.*exp(17.67.*T./(T+243.5));

% then, calculate vapor pressure (Pa) from RH
e = es.*RH/100;

% convert to kPa
e = e/1000;

% calc mass mixing ratio of water vapor to dry air
w = 0.622*e./(P-e);

% calc specific humidity (ratio of vapor to air mass densities
q = w./(w+1);