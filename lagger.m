
function [x_lag,y_lag,lag] = lagger(x,y,x_ind,y_ind,laglim)

% function lagger finds maximum correlation between two time series and 
% shifts datasets to align at that value

% inputs
% x : timeseries 1
% y : timeseries 2
% x_ind : index of column in x to use for aligning, if empty = 1 
% y_ind : index of column in y to use for aligning, if empty = 1 
% laglim : max lag size to search over, if empty = length of x/y

% outputs
% x_lag : lag adjusted timeseries x (padded with NaN)
% y_lag : lag adjusted timeseries y (padded with NaN)
% lag : number of timesteps adjusted

%% error checking

x_lag = NaN;
y_lag = NaN;
lag = NaN;

if nargin < 2
    disp('error in lagger: not enough input elements')
    return
end

if nargin == 2
    laglim = length(x);
    x_ind = 1;
    y_ind = 1;
end
    
if nargin == 4
    laglim = length(x);
end 

if size(x(:,x_ind)) ~= size(y(:,y_ind))
    disp('error in lagger: input arrays not same size')
    return
end


%% find lag between sets (using w) and apply
[a,b] = xcorr(x(:,x_ind), y(:,y_ind),laglim);
lag = b(a==max(a))+1;

if lag > 0
    x_lag = [ x(lag:end,:) ; nan(lag-1,size(x,2))]; 
    y_lag = y;
end
if lag < 0
    x_lag = [nan(abs(lag), size(x,2)) ; x(1:end-abs(lag),:) ];      
    y_lag = y;
end

if lag == 0 
    x_lag = x;
    y_lag = y;
end
