function [RH] = q2RH(q, T)


% convert absolute humidity (mass density) to relative humidity (percent) 
% inputs:
% q - absolute humidity (mmol m3)
% T - air temperature (oC)

% output:
% RH - relative humidity (%)

% convert relative humidity (as percent) to absolute humidity (mass
% density)
% inputs:
% q - relative humidity (as percent)
% T - air temperature (oC)

%q = 6112.*exp(17.67.*T./(T+243.5)).*RH./8.314./(T+273.14);

RH = q.*(T+273.14).*8.314./(6112.*exp(17.67.*T./(T+243.5))); 

