function [q] = RH2q(RH, T)

% convert relative humidity (percent) to absolute humidity (mole
% density)
% inputs:
% RH - relative humidity (percent)
% T - air temperature (oC)

% output:
% q - absolute humidity (mmol m-3)

q = 6112.*exp(17.67.*T./(T+243.5)).*RH./8.314./(T+273.14);