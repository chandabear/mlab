function [] = AFreportplot2d_v7(main, comp)  

% v4 - call new plotting functions (adds secondary y to diff plot and
% updates string format in histogram)
% v5 - adds figure saving in emf format.
% v6 - looks at different regression methods
% v7 - TLS / orthogonal regression now done. Added code for output data for 3 system comparison.

close all
clearvars -except main comp

% load MAIN dataset (the one others are compared)
mn = load([main '.mat']);

mn_lab = mn.lab;
mn_data = mn.data;
header = mn.header;     % take header from the main file only.
if isfield(mn,'unca')   % get matrix of random error estimates, if avail.
    mn_unca = mn.unca;      
else
    mn_unca = nan(size(mn_data));
end

% load comparison datasets
if numel(comp) == 2
    c1 = load([comp{1} '.mat']);
    c1_lab = c1.lab;
    c1_data = c1.data;

    c2 = load([comp{2} '.mat']);
    c2_lab = c2.lab;
    c2_data = c2.data;
else
    c1 = load([comp '.mat']);
    c1_lab = c1.lab;
    c1_data = c1.data;
end
    
if numel(comp) == 2
    foldout = [main(6:end) '_' comp{1}(6:end) '_' comp{2}(6:end)];
else
    foldout = [main(6:end) '_' comp(6:end)];
end

%% 
date_num_mn = mn_data(:,1);
date_num_c1 = date_num_mn;

if numel(comp) == 2
    date_num_c2 = date_num_mn;
end

mn_lmt = [1 length(mn_data)];
c1_lmt = [1 length(mn_data)];
if numel(comp) == 2
    c2_lmt = [1 length(mn_data)];
end

% initialize a counter for screening the paired data
% cols 1-6 - out of bounds ('factor1' times std away from mean) over a span of two 'steps'
% cols 7-12 - out of bounds ('factor2' times std away from mean) over entire span
% col 13-14 - difference exceeds maxdev times from mean difference
cnt = zeros(size(mn_data,2),14);

% initialize stat parameters
slp = nan(size(mn_data,2),1);
int = nan(size(mn_data,2),1);
r2 = nan(size(mn_data,2),1);
nonan = nan(size(mn_data,2),1);

if exist('figures')~=7
    mkdir('figures')
end

%% data plot loop
% loop for each variable
for i = 2:size(mn_data,2)
    %%
    step = 24;
    factor1 = 10;  % moving average for 2x step
    factor2 = 10;  % whole series
    maxdev = 10;
    
    for ii = step+1:length(mn_data)-step-1
        
        mn_test = (c1_data(ii-step:ii+step,i));
        dev_mn_max = nanmean(mn_test) + factor1*nanstd(mn_test);
        dev_mn_min = nanmean(mn_test) - factor1*nanstd(mn_test);
        if mn_data(ii,i)>dev_mn_max
            mn_data(ii,i) = NaN;
            cnt(i,1) = cnt(i,1)+1;
        end
        if mn_data(ii,i)<dev_mn_min
            mn_data(ii,i) = NaN;
            cnt(i,2) = cnt(i,2)+1;
        end
        
        c1_test = (mn_data(ii-step:ii+step,i));
        dev_c1_max = nanmean(c1_test) + factor1*nanstd(c1_test);
        dev_c1_min = nanmean(c1_test) - factor1*nanstd(c1_test);
        if c1_data(ii,i)>dev_c1_max
            c1_data(ii,i) = NaN;
            cnt(i,3) = cnt(i,3)+1;
        end
        if c1_data(ii,i)<dev_c1_min
            c1_data(ii,i) = NaN;
            cnt(i,4) = cnt(i,4)+1;
        end
        
        if numel(comp) == 2
            c2_test = (mn_data(ii-step:ii+step,i));
            dev_c2_max = nanmean(c2_test) + factor1*nanstd(c2_test);
            dev_c2_min = nanmean(c2_test) - factor1*nanstd(c2_test);
            if c2_data(ii,i)>dev_c2_max
                c2_data(ii,i) = NaN;
                cnt(i,5) = cnt(i,5)+1;
            end
            if c2_data(ii,i)<dev_c2_min
                c2_data(ii,i) = NaN;
                cnt(i,6) = cnt(i,5)+1;
            end
        else
            cnt(i,5) = NaN;
            cnt(i,6) = NaN;
        end
    end
    
    mn_data(isnan(c1_data(:,i)),i) = NaN;
    c1_data(isnan(mn_data(:,i)),i) = NaN;
    
    if numel(comp) == 2
        mn_data(isnan(c2_data(:,i)),i) = NaN;
        c2_data(isnan(mn_data(:,i)),i) = NaN;
    end
    
    dev_mn_max = nanmean(mn_data(:,i))+factor2*nanstd(mn_data(:,i));
    dev_mn_min = nanmean(mn_data(:,i))-factor2*nanstd(mn_data(:,i));
    dev_c1_max = nanmean(c1_data(:,i))+factor2*nanstd(c1_data(:,i));
    dev_c1_min = nanmean(c1_data(:,i))-factor2*nanstd(c1_data(:,i));
    
    if numel(comp) == 2
        dev_c2_max = nanmean(c2_data(:,i))+factor2*nanstd(c2_data(:,i));
        dev_c2_min = nanmean(c2_data(:,i))-factor2*nanstd(c2_data(:,i));
    end

    mn_data( ( find(mn_data(:,i)>dev_mn_max)),i) = NaN;
    cnt(i,7) = sum((mn_data(:,i)>dev_mn_max));
    
    mn_data( ( find(mn_data(:,i)<dev_mn_min)),i) = NaN;
    cnt(i,8) = sum((mn_data(:,i)<dev_mn_min));
    
    c1_data( ( find(c1_data(:,i)>dev_c1_max)),i) = NaN;
    cnt(i,9) = sum((c1_data(:,i)>dev_c1_max));
    
    c1_data( ( find(c1_data(:,i)<dev_c1_min)),i) = NaN;
    cnt(i,10) = sum((c1_data(:,i)<dev_c1_min));
    
    if numel(comp) == 2
        c2_data( ( find(c2_data(:,i)>dev_c2_max)),i) = NaN;
        cnt(i,11) = sum((c2_data(:,i)>dev_c2_max));
    
        c2_data( ( find(c2_data(:,i)<dev_c2_min)),i) = NaN;
        cnt(i,12) = sum((c2_data(:,i)<dev_c2_min)); 
    else
        cnt(i,11) = NaN;
        cnt(i,12) = NaN;
    end
    
    mn_data(isnan(c1_data(:,i)),i) = NaN;
    c1_data(isnan(mn_data(:,i)),i) = NaN;
    
    if numel(comp) == 2
        mn_data(isnan(c2_data(:,i)),i) = NaN;
        c2_data(isnan(mn_data(:,i)),i) = NaN;
    end
    
    diff1 = abs(abs(c1_data(:,i)) - abs(mn_data(:,i)));
    mn_data((find(diff1(:)>maxdev*abs(nanmean(diff1)))),i) = NaN;
    c1_data((find(diff1(:)>maxdev*abs(nanmean(diff1)))),i) = NaN;
    cnt(i,13) = sum((diff1(:)>maxdev*abs(nanmean(diff1))));
    
    if numel(comp) == 2
        diff2 = abs(abs(c2_data(:,i)) - abs(mn_data(:,i)));
        mn_data((find(diff2(:)>maxdev*abs(nanmean(diff2)))),i) = NaN;
        c2_data((find(diff2(:)>maxdev*abs(nanmean(diff2)))),i) = NaN;
        cnt(i,14) = sum((diff2(:)>maxdev*abs(nanmean(diff2))));
    else 
        cnt(i,14) = NaN;
    end
    
    if numel(comp) == 2
        minval1 = min([min(mn_data(:,i)),min(c1_data(:,i)),min(c2_data(:,i))]);
        maxval1 = max([max(mn_data(:,i)),max(c1_data(:,i)),max(c2_data(:,i))]);
    else
        minval1 = min([min(mn_data(:,i)),min(c1_data(:,i))]);
        maxval1 = max([max(mn_data(:,i)),max(c1_data(:,i))]);
    end
    minval = (minval1-abs(0.02*minval1));
    maxval = (maxval1+(0.02*maxval1));
    %%
    if minval==0 && maxval==0
        %nix
    elseif isnan(minval)~=1 && isnan(maxval)~=1
        % condition uncertainty matrix to match screened data
        mn_unca(isnan(mn_data)) = NaN;
        
        if numel(comp) == 2
            %%
            [h_fig, slp(i), int(i), r2(i), nonan(i)] = AFplot3d_v3(...
                mn_lab, i, date_num_mn, mn_data, ...
                c1_lab, i, date_num_c1, c1_data, ...
                c2_lab, i, date_num_c2, c2_data, ...
                header{i,1}, header{i,2}, ...
                mn_lmt, c1_lmt, c2_lmt, [minval maxval], 1, 'dd');
        else
            %%
            [h_fig, slp(i), int(i), r2(i), nonan(i)] = AFplot2d_v5(...
                mn_lab, i, date_num_mn, mn_data, mn_unca,...
                c1_lab, i, date_num_c1, c1_data, ...
                header{i,1}, header{i,2}, ...
                mn_lmt, c1_lmt, [minval maxval], 1, 'dd');  
        end
             
        nam = header{i,1};
        namstrg = [num2str(i-1,'%02.0f'),'_',nam];
        
        if exist(['figures/' foldout])==0
            mkdir(['figures/' foldout])
        end
        % first, export bitmap
        export_fig(['figures/' foldout '/' namstrg],'-png', '-opengl', '-nocrop')
        % second, export vector images
        export_fig(['figures/' foldout '/' namstrg],'-pdf', '-eps', '-painters', '-nocrop')
        % third, export EMF
        saveas(gcf,['figures/' foldout '/' namstrg '.emf'])
        close (h_fig);
    end

end

%% write regression statistics to CSV file
if numel(comp) ~= 2
    otherstats = [nanmean(mn_data)', nanstd(mn_data)', nanmax(mn_data)', nanmin(mn_data)', nanmean(c1_data)', nanstd(c1_data)', nanmax(c1_data)', nanmin(c1_data)'];
    
    datout = [header(:,1), num2cell(slp), num2cell(int), num2cell(r2), num2cell(nonan), num2cell(otherstats)];
    fid = fopen(['figures/' foldout '/_stats_for_' foldout '.csv'], 'w');
    
    fprintf(fid, ' ,slope,intercept,R2,N,mean1,std1,max1,min1,mean2,std2,max2,min2\r\n');
    
    for i = 1:size(header,1)
        fprintf(fid, '%s,%f,%f,%f,%i,%f,%f,%f,%f,%f,%f,%f,%f\r\n', datout{i,:});
    end
    fclose(fid);
    
    %% write data USED in figure generation. 
    
    for k = 1:size(mn_data,2)
        used_data(:,(k-1)*2+1:k*2) = [mn_data(:,k) c1_data(:,k)];
    end
    fid = fopen(['figures/' foldout '/_used_data.csv'], 'w');
    for k = 1:size(mn_data,2)
        fprintf(fid, '%s,', mn_lab);
        fprintf(fid, '%s,', c1_lab);
    end
    fprintf(fid, '\r\n');
    
    for k = 1:size(mn_data,2)
        fprintf(fid, '%s,', header{k,1});
        fprintf(fid, '%s,', header{k,1});
    end
    fprintf(fid, '\r\n');
    
    for k = 1:size(mn_data,2)
        fprintf(fid, '%s,', header{k,2});
        fprintf(fid, '%s,', header{k,2});
    end
    fprintf(fid, '\r\n');
    
    fclose(fid);
    
    dlmwrite(['figures/' foldout '/_used_data.csv'],used_data,'-append','delimiter',',','precision','%.6f')
end

if numel(comp) == 2   
    dlmwrite(['figures/' foldout '/_used_data.csv'],[mn_data c1_data c2_data],'-append','delimiter',',','precision','%.6f') 
end

%% display matrix of # of screened values
cnt = [(1:size(mn_data,2))' cnt];
display(cnt)
