function [h_fig, slp, int, r2, nonan] =  AFplot2d_v5(ps_string,ps_col,datetime_num_ps,data_corr_ps,unca_corr_ps,cs_string,cs_col,datetime_num_cs,data_corr_cs,...
    title_string,label_string,index_ps,index_cs,data_limits,timetick_interval,timetick_mode)
% Function for plotting the results of the AmeriFlux intercomparisons
% v3 - added percent difference on secondary y-axis. updated formating on histogram labeling (12/2015)
% v4 - move from orthogonal least squares regression to orthogonal regression (08/2017)
% v5 - update histogram plotting to use Freedman-Diaconis rule

% Setting a default time tick interval and mode if they were not provided
if nargin <= 14
    timetick_interval = 1;
end;
if nargin <= 15
    timetick_mode = 'dd/mm';
end;

% Determining close data limits
xlim_data   =   [floor(min(datetime_num_ps(index_ps(1)))) ceil(max(datetime_num_ps(index_ps(2))))];

% Calling a new plot
h_fig   =   figure;

set(gcf,'Position',[1 1 600 800])
set(gcf,'Color','white')

%% Plotting the time series
subplot (10,2,1:8);
box on;
if strcmp('\circ',label_string)
    ha = line (datetime_num_ps(index_ps(1):index_ps(2)),data_corr_ps(index_ps(1):index_ps(2),ps_col),'linestyle','none','color','k','linewidth',1,'marker','o','markersize',4,'markerfacecolor','k');
    hb = line (datetime_num_cs(index_cs(1):index_cs(2)),data_corr_cs(index_cs(1):index_cs(2),cs_col),'linestyle','none','color','b','linewidth',1,'marker','+','markersize',4,'markerfacecolor','b');
else
    if sum(~isnan(unca_corr_ps(index_ps(1):index_ps(2),ps_col)))~=0         % add random uncertainty to graph if data avail. 
        num_nan = diff(find(isnan(data_corr_ps(index_ps(1):index_ps(2),ps_col))));
        idx = find(num_nan>1);
        y = cumsum(num_nan);
        brack_idx = [y(idx-1)+2 y(idx)];
         for i = 1:size(brack_idx,1)
             he = jbfill(datetime_num_ps(brack_idx(i,1):brack_idx(i,2))', (data_corr_ps(brack_idx(i,1):brack_idx(i,2),ps_col)+unca_corr_ps(brack_idx(i,1):brack_idx(i,2),ps_col))', (data_corr_ps(brack_idx(i,1):brack_idx(i,2),ps_col)-unca_corr_ps(brack_idx(i,1):brack_idx(i,2),ps_col))', rgb('very light grey'),rgb('grey'), 1,1);
         end
    end
    ha = line (datetime_num_ps(index_ps(1):index_ps(2)),data_corr_ps(index_ps(1):index_ps(2),ps_col),'linestyle','-','color','k');
    hb = line (datetime_num_cs(index_cs(1):index_cs(2)),data_corr_cs(index_cs(1):index_cs(2),cs_col),'linestyle','--','color','b');
end;

% zero line
line (xlim_data, 0*xlim_data,'linestyle',':','color','k','linewidth',0.5);

% format axes
xlim (xlim_data);
set (gca,'XTickLabel',[])  % no tick label
set (gca,'XTick',floor(min(datetime_num_ps(index_ps(1)))) : timetick_interval : ceil(max(datetime_num_ps(index_ps(2)))));
set (gca,'XMinorTick','on')
ylim (data_limits);
ylabel (label_string,'fontsize',10);
title (title_string,'fontsize',10);

if strcmp('\circ',label_string)
    set (gca,'ytick',0:45:360);
end;
% legend
if strcmp('\circ',label_string)
    h_leg = legend ([ha hb], ps_string,cs_string,'location','Best'); 
    set(h_leg,'fontsize',10);
    %legend (h_leg,'boxoff');
else
    if sum(~isnan(unca_corr_ps(index_ps(1):index_ps(2),ps_col)))~=0
        h_leg = legend ([ha he hb], ps_string,'random unc.',cs_string,'location','Best'); 
        set (h_leg,'fontsize',10);
        %legend (h_leg,'boxon');
    else
        h_leg = legend ([ha hb], ps_string,cs_string,'location','Best'); 
        set (h_leg,'fontsize',10);
        %legend (h_leg,'boxon');
    end
end;

%% plot difference time series
HS = subplot (10,2,9:12);
box on;

dif = data_corr_ps(index_ps(1):index_ps(2),ps_col) - data_corr_cs(index_cs(1):index_cs(2),cs_col);
line (datetime_num_ps(index_ps(1):index_ps(2)),dif,'linestyle','-','color','k');
% zero line
line (xlim_data, 0*xlim_data,'linestyle',':','color','k','linewidth',0.5);

% add secondary y-axis ticks as percentage of mean
%scaling_mean = nanmax([data_corr_ps(index_ps(1):index_ps(2),ps_col); data_corr_cs(index_cs(1):index_cs(2),cs_col)]);  
%h2 = axes('Position',get(gca,'Position'),'Yaxislocation','Right','YLim',get(gca,'YLim')./scaling_mean*100,'XTick',[],'Color','none');

xlim (xlim_data);
set (gca,'XTick',floor(min(datetime_num_ps(index_ps(1)))) : timetick_interval : ceil(max(datetime_num_ps(index_ps(2)))));
set (gca,'XMinorTick','on')
datetick ('x',timetick_mode,'keeplimits','keepticks')

if ~nansum(dif == 0) 
    ylim ([-nanstd(abs(dif))*4+nanmean(dif), nanstd(abs(dif))*4+nanmean(dif)])
end

xlabel (HS,['Date [' timetick_mode ']'],'fontsize',10);
ylabel (HS,[ps_string ' - ' cs_string],'fontsize',10);
%ylabel (h2,'Percent of mean [%]')

%% creating the scatter plot 
% sorting out NaN in data
data_scat_ps        =   data_corr_ps(index_ps(1) : index_ps(2),ps_col);
data_scat_cs        =   data_corr_cs(index_cs(1) : index_cs(2),cs_col);
index_nonnan_ps     =   find(~isnan(data_scat_ps));
index_nonnan_cs     =   find(~isnan(data_scat_cs));
index_nonnan        =   intersect(index_nonnan_ps,index_nonnan_cs);

% In case of winddir data plotted, the data around 0 and 360 deg can be
% discarded for the scatter plot, as they give unreasonable results for the regression
if strcmp('\circ',label_string)
    index_northjump =   find(((data_scat_ps < 100) & (data_scat_cs > 260)) | ...
        ((data_scat_cs < 100) & (data_scat_ps > 260)));
    index_northjump =   intersect(index_nonnan,index_northjump);
    index_nonnan        =   setdiff(index_nonnan,index_northjump);
end;

subplot (10,2,15:2:19);
box on; %axis square;
line (data_scat_ps(index_nonnan),data_scat_cs(index_nonnan),'linestyle','none','marker','.','markersize',7,'color','k');

line (data_limits,[0 0],'linestyle',':','linewidth',0.5,'color','k');
line (data_limits,data_limits,'linestyle',':','linewidth',0.5,'color','k');
line ([0 0],data_limits,'linestyle',':','linewidth',0.5,'color','k');

%beta        =   polyfit(data_scat_ps(index_nonnan),data_scat_cs(index_nonnan),1);

% Calculate linear regression using Total Least Squares / Orthogonal (TLS)
[~,~,beta] = rTLS(data_scat_ps(index_nonnan),data_scat_cs(index_nonnan));

% updated - squared corrcoef so that it is r2
corr_r      =   corrcoef(data_scat_ps(index_nonnan),data_scat_cs(index_nonnan)).^2;
line (data_limits,[polyval(beta,data_limits(1)) polyval(beta,data_limits(2))],'linestyle','-','color','r','linewidth',0.5);

if numel(corr_r)==1
    corr_r(2)=corr_r;
end

ylim (data_limits);
xlim (data_limits);

if strcmp('\circ',label_string)
    set (gca,'ytick',0:90:360);
    set (gca,'xtick',0:90:360);
end;

xlabel ([ps_string,label_string],'fontsize',8);
ylabel ([cs_string,label_string],'fontsize',8);

% text label for regression info
scale_range     =   abs(data_limits(1) - data_limits(2));
if beta(2) >= 0
    text (data_limits(1)+0.1*scale_range, data_limits(2)-0.1*scale_range,['y = ',num2str(beta(1),'%4.2f'),'x+',num2str(beta(2),'%4.2f')],'fontsize',10);
    text (data_limits(1)+0.1*scale_range, data_limits(2)-0.2*scale_range,['R^2 = ',num2str(corr_r(2),'%4.2f')],'fontsize',10);                                                                   
    text (data_limits(1)+0.1*scale_range, data_limits(2)-0.3*scale_range,['N = ',num2str(length(index_nonnan))],'fontsize',10);                                                                   
else
    text (data_limits(1)+0.1*scale_range, data_limits(2)-0.1*scale_range,['y = ',num2str(beta(1),'%4.2f'),'x', num2str(beta(2),'%4.2f')],'fontsize',10);
    text (data_limits(1)+0.1*scale_range, data_limits(2)-0.2*scale_range,['R^2 = ',num2str(corr_r(2),'%4.2f')],'fontsize',10);                                                                   
    text (data_limits(1)+0.1*scale_range, data_limits(2)-0.3*scale_range,['N = ',num2str(length(index_nonnan))],'fontsize',10);    
end;

slp = beta(1);
int = beta(2);
r2 = corr_r(2);
nonan = length(index_nonnan);

%% make histogram plot of differences
subplot (10,2,16:2:20);
box on;

histogram(dif,'BinMethod','fd','FaceColor','w','FaceAlpha',1,'EdgeColor','b')

if ~nansum(dif == 0)
    xlim ([-nanstd(abs(dif))*4+nanmean(dif), nanstd(abs(dif))*4+nanmean(dif)])
end

xlabel ([ps_string ' - ' cs_string],'fontsize',8);
ylabel ('Number','fontsize',8);

line([0 0], get(gca,'YLim'),'linestyle',':','linewidth',0.5,'color','k');

% text label for histogram info
xpos = get(gca,'XLim');
ypos = get(gca,'YLim');
xrng = diff(xpos);
yrng = diff(ypos);

% format was %4.2f
text (xpos(1)+0.05*xrng, ypos(1)+0.9*yrng,['mean = ',num2str(nanmean(dif),'%2.2g')],'fontsize',10);
text (xpos(1)+0.05*xrng, ypos(1)+0.8*yrng,['median = ',num2str(nanmedian(dif),'%2.2g')],'fontsize',10);
text (xpos(1)+0.05*xrng, ypos(1)+0.7*yrng,['std = ',num2str(nanstd(dif),'%2.2g')],'fontsize',10);

%%
%text (data_limits(1)-0.5*scale_range, data_limits(1)-0.5*scale_range,['Period: ',datestr(datetime_num_ps(index_ps(1))),' to ',datestr(datetime_num_ps(index_ps(2)))],'fontsize',10);
