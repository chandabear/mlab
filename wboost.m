function wb = wboost(w)
% Apply missing calibration factor of Gill sonic anemometer
% the so called, w-boost. 
% 16.6% for upwards flow
% 28.9% for downwards flow

wb = w;
wb(w>0) = w(w>0)*1.166;
wb(w<0) = w(w<0)*1.289;

% wb(w>0) = w(w>0)*1.289;
% wb(w<0) = w(w<0)*1.166;
end