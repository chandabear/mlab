% Function for plotting the results of the AmeriFlux intercomparisons

function [h_fig, slp, int, r2, nonan] =  AFplot3d(...
    mn_string, mn_col, datetime_num_mn, data_corr_mn,...
    c1_string, c1_col, datetime_num_c1, data_corr_c1,...
    c2_string, c2_col, datetime_num_c2, data_corr_c2,...
    title_string, label_string, ...
    index_mn, index_c1, index_c2, ...
    data_limits,timetick_interval,timetick_mode)

% Setting a default time tick interval and mode if they were not provided
if nargin <= 18
    timetick_interval = 1;
end;
if nargin <= 19
    timetick_mode = 19;
end;

% Determining close data limits
xlim_data   =   [floor(min(datetime_num_mn(index_mn(1)))) ceil(max(datetime_num_mn(index_mn(2))))];

% Calling a new plot
h_fig   =   figure;

set(gcf,'Position',[1 1 600 800])
set(gcf,'Color','white')

%% Plotting the time series
subplot (10,2,1:8);
box on;
if strcmp('\circ',label_string)
    line (datetime_num_mn(index_mn(1):index_mn(2)),data_corr_mn(index_mn(1):index_mn(2),mn_col),'linestyle','none','color','k','linewidth',1,'marker','o','markersize',4,'markerfacecolor','k');
    line (datetime_num_c1(index_c1(1):index_c1(2)),data_corr_c1(index_c1(1):index_c1(2),c1_col),'linestyle','none','color','b','linewidth',1,'marker','+','markersize',4,'markerfacecolor','b');
    line (datetime_num_c2(index_c2(1):index_c2(2)),data_corr_c2(index_c2(1):index_c2(2),c2_col),'linestyle','none','color','r','linewidth',1,'marker','+','markersize',4,'markerfacecolor','r');
else
    line (datetime_num_mn(index_mn(1):index_mn(2)),data_corr_mn(index_mn(1):index_mn(2),mn_col),'linestyle','-','color','k');
    line (datetime_num_c1(index_c1(1):index_c1(2)),data_corr_c1(index_c1(1):index_c1(2),c1_col),'linestyle','--','color','b');
    line (datetime_num_c2(index_c2(1):index_c2(2)),data_corr_c2(index_c2(1):index_c2(2),c2_col),'linestyle','--','color','r');
end;

% zero line
line (xlim_data, 0*xlim_data,'linestyle',':','color','k','linewidth',0.5);

% format axes
xlim (xlim_data);
set (gca,'XTickLabel',[])  % no tick label
set (gca,'XTick',floor(min(datetime_num_mn(index_mn(1)))) : timetick_interval : ceil(max(datetime_num_mn(index_mn(2)))));
set (gca,'XMinorTick','on')
ylim (data_limits);
ylabel (label_string,'fontsize',10);
title (title_string,'fontsize',10);

if strcmp('\circ',label_string)
    set (gca,'ytick',0:45:360);
end;
% legend
if ~strcmp('\circ',label_string)
    h_leg = legend (mn_string,c1_string,c2_string,'location','Best'); 
    set (h_leg,'fontsize',10);
    legend (h_leg,'boxoff');
else
    h_leg = legend (mn_string,c1_string,c2_string,'location','Best'); 
    set (h_leg,'fontsize',10);
    legend (h_leg,'boxon');
end;

%% plot difference time series
subplot (10,2,9:12);
box on;

dif1 = data_corr_mn(index_mn(1):index_mn(2),mn_col) - data_corr_c1(index_c1(1):index_c1(2),c1_col);
line (datetime_num_mn(index_mn(1):index_mn(2)),dif1,'linestyle','-','color','b');
%plot(datetime_num_mn(index_ps(1):index_ps(2)),dif1,'b.');

dif2 = data_corr_mn(index_mn(1):index_mn(2),mn_col) - data_corr_c2(index_c2(1):index_c2(2),c2_col);
line (datetime_num_mn(index_mn(1):index_mn(2)),dif2,'linestyle','-','color','r');
%plot(datetime_num_mn(index_ps(1):index_ps(2)),dif2,'.r');

% zero line
line (xlim_data, 0*xlim_data,'linestyle',':','color','k','linewidth',0.5);

xlim (xlim_data);
set (gca,'XTick',floor(min(datetime_num_mn(index_mn(1)))) : timetick_interval : ceil(max(datetime_num_mn(index_mn(2)))));
set (gca,'XMinorTick','on')
datetick ('x',timetick_mode,'keeplimits','keepticks')

if ~(nansum(dif1 == 0) && nansum(dif1 == 0))
    ylim ([min([-nanstd(abs(dif1))*4.25+nanmean(dif1),-nanstd(abs(dif2))*4.25+nanmean(dif2)]), max([nanstd(abs(dif1))*4.25+nanmean(dif1),nanstd(abs(dif2))*4.25+nanmean(dif2)])])
end

xlabel ('Date [dd/mm]','fontsize',10);
ylabel ({[mn_string ' - ' c1_string];[mn_string ' - ' c2_string]},'fontsize',8);

%% creating the scatter plot 
% sorting out NaN in data
data_scat_mn        =   data_corr_mn(index_mn(1) : index_mn(2),mn_col);
data_scat_cs1       =   data_corr_c1(index_c1(1) : index_c1(2),c1_col);
data_scat_cs2       =   data_corr_c2(index_c2(1) : index_c2(2),c2_col);
index_nonnan_mn     =   find(~isnan(data_scat_mn));
index_nonnan_cs1    =   find(~isnan(data_scat_cs1));
index_nonnan_cs2    =   find(~isnan(data_scat_cs2));

index_nonnan1       =   intersect(index_nonnan_mn,index_nonnan_cs1);
index_nonnan2       =   intersect(index_nonnan_mn,index_nonnan_cs2);

% In case of winddir data plotted, the data around 0 and 360 deg can be
% discarded for the scatter plot, as they give unreasonable results for the regression
if strcmp('\circ',label_string)
    index_northjump =   find(((data_scat_mn < 100) & (data_scat_cs1 > 260)) | ...
        ((data_scat_cs1 < 100) & (data_scat_mn > 260)));
    index_northjump =   intersect(index_nonnan1,index_northjump);
    index_nonnan1    =   setdiff(index_nonnan1,index_northjump);
end;

subplot (10,2,15:2:19);
box on; %axis square;
line (data_scat_mn(index_nonnan1),data_scat_cs1(index_nonnan1),'linestyle','none','marker','.','color','b');  %'markersize',7,
line (data_scat_mn(index_nonnan2),data_scat_cs2(index_nonnan2),'linestyle','none','marker','.','color','r');  %'markersize',7,

line (data_limits,[0 0],'linestyle',':','linewidth',0.5,'color','k');
line (data_limits,data_limits,'linestyle','-','linewidth',0.5,'color','k');
line ([0 0],data_limits,'linestyle',':','linewidth',0.5,'color','k');

beta1        =   polyfit(data_scat_mn(index_nonnan1),data_scat_cs1(index_nonnan1),1);
% updated - squared corrcoef so that it is r2
corr_r1      =   corrcoef(data_scat_mn(index_nonnan1),data_scat_cs1(index_nonnan1)).^2;
line (data_limits,[polyval(beta1,data_limits(1)) polyval(beta1,data_limits(2))],'linestyle','-','color','b','linewidth',0.5);

beta2        =   polyfit(data_scat_mn(index_nonnan2),data_scat_cs2(index_nonnan2),1);
% updated - squared corrcoef so that it is r2
corr_r2      =   corrcoef(data_scat_mn(index_nonnan2),data_scat_cs2(index_nonnan2)).^2;
line (data_limits,[polyval(beta2,data_limits(1)) polyval(beta2,data_limits(2))],'linestyle','-','color','r','linewidth',0.5);

if numel(corr_r1)==1
    corr_r1(2)=corr_r1;
end

if numel(corr_r2)==1
    corr_r2(2)=corr_r2;
end

ylim (data_limits);
xlim (data_limits);

if strcmp('\circ',label_string)
    set (gca,'ytick',0:90:360);
    set (gca,'xtick',0:90:360);
end;

xlabel ([mn_string, '[' label_string , ']'],'fontsize',8);
ylabel ({c1_string; c2_string},'fontsize',8);

% text label for regression info
scale_range     =   abs(data_limits(1) - data_limits(2));

text (data_limits(1)+0.1*scale_range, data_limits(2)-0.15*scale_range,...
    {['y = ',num2str(beta1(1),'%4.2f'),'x', num2str(beta1(2),'%+4.2f')] ; ...
    ['R^2 = ',num2str(corr_r1(2),'%4.2f')] ; ...
    ['N = ',num2str(length(index_nonnan1))]} ...
    ,'fontsize',8,'color','b');

text (data_limits(1)+0.55*scale_range, data_limits(1)+0.2*scale_range,...
    {['y = ',num2str(beta2(1),'%4.2f'),'x', num2str(beta2(2),'%+4.2f')] ; ...
    ['R^2 = ',num2str(corr_r2(2),'%4.2f')] ; ...
    ['N = ',num2str(length(index_nonnan2))]} ...
    ,'fontsize',8,'color','r');

slp = beta1(1);
int = beta1(2);
r2 = corr_r1(2).^2;
nonan = length(index_nonnan1);

%% make histogram plot of differences
subplot (10,2,16:2:20);

box on

bin_std = mean([nanstd(dif1), nanstd(dif2)]);
bin_mn = mean([nanmean(dif1), nanmean(dif2)]);

bins = linspace(bin_mn-bin_std*4,bin_mn+bin_std*4,13);
n1 = hist(dif1,bins);
n2 = hist(dif2,bins);

gg = mean(diff(bins));

h1 = bar(bins-gg*0.225,n1',0.45,'b');
hold on
h2 = bar(bins+gg*0.225,n2',0.45,'r');
hold off

%set(h1,'FaceColor','none','EdgeColor','b')
%set(h2,'FaceColor','none','EdgeColor','r')

if ~(nansum(dif1 == 0) && nansum(dif1 == 0))
    xlim ([min([-nanstd(abs(dif1))*4.25+nanmean(dif1),-nanstd(abs(dif2))*4.25+nanmean(dif2)]), max([nanstd(abs(dif1))*4.25+nanmean(dif1),nanstd(abs(dif2))*4.25+nanmean(dif2)])])
end

line([0 0], get(gca,'YLim'),'linestyle',':','linewidth',0.5,'color','k');

xlabel ({[mn_string '- ' c1_string]; [mn_string '- ' c2_string]},'fontsize',8);
ylabel ('Number','fontsize',8);

% text label for histogram info
xpos = get(gca,'XLim');
ypos = get(gca,'YLim');
xrng = diff(xpos);
yrng = diff(ypos);

text (xpos(1)+0.05*xrng, ypos(1)+0.85*yrng,...
    {['mean = ' ,num2str(nanmean(dif1),'%4.2f')]; ...
    ['median = ',num2str(nanmedian(dif1),'%4.2f')]; ...
    ['std = ',num2str(nanstd(dif1),'%4.2f')]...
    },'fontsize',8, 'color','b');

text (xpos(1)+0.65*xrng, ypos(1)+0.85*yrng,...
    {['mean = ' ,num2str(nanmean(dif2),'%4.2f')]; ...
    ['median = ',num2str(nanmedian(dif2),'%4.2f')]; ...
    ['std = ',num2str(nanstd(dif2),'%4.2f')]...
    },'fontsize',8, 'color','r');

%%
%text (data_limits(1)-0.5*scale_range, data_limits(1)-0.5*scale_range,['Period: ',datestr(datetime_num_ps(index_ps(1))),' to ',datestr(datetime_num_ps(index_ps(2)))],'fontsize',10);
