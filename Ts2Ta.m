function [Ta] = Ts2Ta(Ts, RH, T, P)

% convert sonic temperature (percent) to specific humidity (ratio of mass
% mixing ratio of water vapor to mass mixing ratio of air)

% inputs:
% Ts - sonic temperature (oC)
% RH - relative humidity (percent)
% T - air temperature (oC)
% P - pressure (kPa)

% output:
% Ta - air temperature as derived from sonic (oC)

% convert to K
TsK = Ts + 273.15;

% calculate specific humidity from RH, T, P
q = RH2spechum(RH, T, P);

% convert sonic temp to air temp (accounting for presence of water vapor)
Ta = TsK./(1+0.51*q);

%convert back to C from K
Ta = Ta - 273.15;