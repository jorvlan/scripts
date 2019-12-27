%% 2nd level analysis

%% Time-series

%% Initialize

% for Pupil_2ndlevel_initialize.m
%  if 
%    you have not run Pupil_2ndlevel_initialize.m before subject 001
%  then 
%    run Pupil_2ndlevel_initialize.m
%  else
%    skip Pupil_2ndlevel_initialize.m and run the current script. 
% end

%% Initialize
subject = '001';

conditions = {'threat_low','threat_high','safe_low','safe_high','shock'};

%%%%%%%%%%%%%%% only thing you need to change by hand, the rest is automated.
participant = 1; 
%%%%%%%%%%%%%%% only thing you need to change by hand, the rest is automated.

clc; close all; clearvars -except subject conditions participant;


%% create correct path, add functions and scripts
restoredefaultpath;
addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
addpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil');

% Define where saved data and figures are stored 
conf.output.dir = [ '/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/2ndlevel' ];
conf.output.save = 'yes';
if ~exist(conf.output.dir)
    mkdir(conf.output.dir);
end

%Define input directory and files
conf.input.matdir = ['/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/' subject '/results/Data'];

conf.input.matfiles = {};
for i = 1:length(conditions)
    conf.input.matfiles{i} = pf_findfile(conf.input.matdir,['/' subject '_average_' conditions{i} '_time_course.mat/'],'fullfile'); 
end

conf.input.groupdir = ['/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/2ndlevel'];

conf.input.groupfiles = {};
for j = 1:length(conditions)
    conf.input.groupfiles{j} = pf_findfile(conf.input.groupdir,['/group_' conditions{j} '_time_course.mat/'], 'fullfile');
end


%This function results in a dataframes cell within each cell the different conditions 
% dataframes = {};
% for i = 1:length(conf.input.matfiles)
%     dataframes{i} = load(conf.input.matfiles{i});
% end

% This function results in 5 dataframes as double variables
dataframes = {};
for i = 1:length(conf.input.matfiles)
    dataframes{i} = conf.input.matfiles{i};
    load(dataframes{i})
end

%This function results in the 5 group dataframes that will be saved later
group_dataframes = {};
for j = 1:length(conf.input.groupfiles)
    group_dataframes{j} = conf.input.groupfiles{j};
    load(group_dataframes{j})
end


%Save the average pupil values time course dataframes in the 2ndlevel folder, so that later on the timecourses of the other participants can be added to that dataframe 
if strcmp(conf.output.save,'yes')
    group_threat_low_time_course(participant,:) = average_threat_low_time_course;
    save(fullfile(conf.output.dir,[ 'group_threat_low_time_course']),'group_threat_low_time_course'); 
end

%Save the average pupil values time course dataframes in the 2ndlevel folder, so that later on the timecourses of the other participants can be added to that dataframe 
if strcmp(conf.output.save,'yes')
    group_threat_high_time_course(participant,:) = average_threat_high_time_course; 
    save(fullfile(conf.output.dir,[ 'group_threat_high_time_course']),'group_threat_high_time_course'); 
end

%Save the average pupil values time course dataframes in the 2ndlevel folder, so that later on the timecourses of the other participants can be added to that dataframe 
if strcmp(conf.output.save,'yes')
    group_safe_low_time_course(participant,:) = average_safe_low_time_course; 
    save(fullfile(conf.output.dir,[ 'group_safe_low_time_course']),'group_safe_low_time_course'); 
end

%Save the average pupil values time course dataframes in the 2ndlevel folder, so that later on the timecourses of the other participants can be added to that dataframe 
if strcmp(conf.output.save,'yes')
    group_safe_high_time_course(participant,:) = average_safe_high_time_course; 
    save(fullfile(conf.output.dir,[ 'group_safe_high_time_course']),'group_safe_high_time_course'); 
end

%Save the average pupil values time course dataframes in the 2ndlevel folder, so that later on the timecourses of the other participants can be added to that dataframe 
if strcmp(conf.output.save,'yes')
    group_shock_time_course(participant,:) = average_shock_time_course;
    save(fullfile(conf.output.dir,[ 'group_shock_time_course']),'group_shock_time_course'); 
end


%% Pupil diameter average values

%% Initialize
conf.input.statsdir = ['/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/' subject '/results/Data'];

conf.input.statsfiles = {};
for i = 1:length(conditions)
    conf.input.statsfiles{i} = pf_findfile(conf.input.statsdir,['/' subject '_' conditions{i} '_statistics.mat/'],'fullfile'); 
end

stats_dataframes = {};
for i = 1:length(conf.input.statsfiles)
    stats_dataframes{i} = conf.input.statsfiles{i};
    load(stats_dataframes{i})
end


conf.input.groupstatsdir = ['/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/2ndlevel'];
conf.input.groupstatsfile = ['/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/2ndlevel/group_statistics.mat'];
group_statistics = conf.input.groupstatsfile;
load(group_statistics);


%% Save the group_statistics dataframe (.mat) 
%Save the average pupil values time course dataframes in the 2ndlevel folder, so that later on the timecourses of the other participants can be added to that dataframe 
if strcmp(conf.output.save,'yes')
    group_statistics(participant,1) = threat_low_statistics(1,7);  % mean
    group_statistics(participant,6) = threat_low_statistics(2,7);  % sd
    group_statistics(participant,2) = threat_high_statistics(1,7); % mean
    group_statistics(participant,7) = threat_high_statistics(2,7); % sd
    group_statistics(participant,3) = safe_low_statistics(1,7);    % mean
    group_statistics(participant,8) = safe_low_statistics(2,7);    % sd
    group_statistics(participant,4) = safe_high_statistics(1,7);   % mean
    group_statistics(participant,9) = safe_high_statistics(2,7);   % sd
    group_statistics(participant,5) = shock_statistics(1,2);       % mean
    group_statistics(participant,10) = shock_statistics(2,2);      % sd
    save(fullfile(conf.output.dir,[ 'group_statistics']),'group_statistics'); 
end


%% Export to .csv for plotting in Python

%Create header lines 
headers = [0,0,0,0,0,0,0,0,0,0]; %must be numerical for csvwrite to export. (does not accept string values). Column headers can be renamed by pupil_df.columns [] (in python)
%Add header lines to string data frames
group_statistics = [headers; group_statistics];
group_statistics_test = load('group_statistics_test.mat');
csvwrite('group_statistics_test.csv', group_statistics_test.group_statistics);

%% Export to .csv for statistical testing in R
group_statistics_test = load('group_statistics_test.mat');
%For statistical testing in R, remove the headers = [0,0,0,0,0,0,0,0,0,0]; 
if group_statistics(1,:) == 0
    group_statistics(1,:) = [];
else
    ('The first row does not contain 0s');
end

csvwrite('group_statistics_test.csv', group_statistics_test.group_statistics);
%% Export to cell for plotting with Matlab (see avn_plotBarScatter_adjusted.m)
%If plotting in Matlab, remove the headers = [0,0,0,0,0,0,0,0,0,0]; 
if group_statistics(1,:) == 0
    group_statistics(1,:) = [];
else
    ('The first row does not contain 0s');
end

inData{:,1} = group_statistics(:,4); % safe-low
inData{:,1}(:,2) = group_statistics(:,1); % threat-low
inData{:,2} = group_statistics(:,3); % safe-high
inData{:,2}(:,2) = group_statistics(:,2); % threat-high
%Save the dataframe
if strcmp(conf.output.save,'yes')
    save(fullfile(conf.output.dir,[ 'inData']),'inData'); 
end
    

%% Put all the average thr_fix, thr_odd, safe_fix, safe_odd, shock values in 5 variables for average N = 17 time-course plotting and save pupil values time courses threat-rest (data)
cd('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS/-6 +3 data');

%Load the time course + average across 17 subjects for threat-rest
load('pupil_time_courses_threat_rest_n17.mat');                      
load('average_pupil_time_courses_threat_rest_n17');

%Load the time course + average across 17 subjects for threat-odd
load('pupil_time_courses_threat_odd_n17.mat');                       
load('average_pupil_time_courses_threat_odd_n17');

%Load the time course + average across 17 subjects for safe-rest
load('pupil_time_courses_safe_rest_n17.mat');   
load('average_pupil_time_courses_safe_rest_n17');

%Load the time course + average across 17 subjects for safe-odd
load('pupil_time_courses_safe_odd_n17.mat');    
load('average_pupil_time_courses_safe_odd_n17');

%Load the time course + average across 17 subjects for shock
load('pupil_time_courses_shock_n17.mat');  
load('average_pupil_time_courses_shock_n17');

%Plot the average time-courses ( N = 17 )
fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
    
plot(average_pupil_time_courses_threat_rest_n17(1,1:69000)); % plot(average_pupil_time_courses_threat_rest_n17(1,1:60000)); 

        xlim([0 69000])  %x = linspace(0,72000); %x = linspace(0,60000);
        xticks([0 6000 16000 26000 36000 46000 56000 66000 69000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-6','0','10','20','30','40','50','60','+3'})
        h = xline(6000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(66000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil diameter');
        title(['Threat-rest average time course (N = 17)']); %title(['TOS all conditions average time course (N = 17)']);
 
        fig_name = ['threat_rest_average_time_course_n17']; %fig_name = ['threat_rest_average_time_course_n17'];
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'jpg');
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'fig');
%hold on
plot(average_pupil_time_courses_threat_odd_n17(1,1:69000)); %plot(average_pupil_time_courses_threat_odd_n17(1,1:60000)); 

     
xlim([0 69000])  %x = linspace(0,72000); %x = linspace(0,60000);
        xticks([0 6000 16000 26000 36000 46000 56000 66000 69000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-6','0','10','20','30','40','50','60','+3'})
        h = xline(6000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(66000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil dilation');
        title(['threat-odd average time course (N = 17)']);
 
        fig_name = ['threat_odd_average_time_course_n17']; % fig_name = ['threat_odd_average_time_course_n17'];
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'jpg');
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'fig');

       % legend('threat-rest','threat-odd')     
plot(average_pupil_time_courses_safe_rest_n17(1,1:69000));%plot(average_pupil_time_courses_safe_rest_n17(1,1:60000));


        xlim([0 69000])  %x = linspace(0,72000); %x = linspace(0,60000);
        xticks([0 6000 16000 26000 36000 46000 56000 66000 69000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-6','0','10','20','30','40','50','60','+3'})
        h = xline(6000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(66000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil dilation');
        title(['safe-rest average time course (N = 17)']);
 
        fig_name = ['safe_rest_average_time_course_n17']; % fig_name = ['safe_rest_average_time_course_n17'];
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'jpg');
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'fig');
%hold on
plot(average_pupil_time_courses_safe_odd_n17(1,1:69000));%plot(average_pupil_time_courses_safe_odd_n17(1,1:60000));


        xlim([0 69000])  %x = linspace(0,72000); %x = linspace(0,60000);
        xticks([0 6000 16000 26000 36000 46000 56000 66000 69000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-6','0','10','20','30','40','50','60','+3'})
        h = xline(6000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(66000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil dilation');
        title(['Safe-odd average time course (N = 17)']);
 
        fig_name = ['safe_odd_average_time_course_n17']; % fig_name = ['safe_odd_average_time_course_n17'];
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'jpg');
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'fig');

%leg2 = legend('safe-rest','safe-odd')
%set(leg2, 'Position', [.6 .8 .11 .08], 'Color', [1 1 1],'FontSize',10);

plot(average_pupil_time_courses_shock_n17(1,1:69000));%plot(average_pupil_time_courses_shock_n17(1,1:60000));

        xlim([0 69000])  %x = linspace(0,72000); %x = linspace(0,60000);
        xticks([0 6000 16000 26000 36000 46000 56000 66000 69000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-6','0','10','20','30','40','50','60','+3'})
        h = xline(6000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(66000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil dilation');
        title(['shock average time course (N = 17)']);
 
        fig_name = ['shock_average_time_course_n17']; % fig_name = ['shock_average_time_course_n17'];
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'jpg');
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS',fig_name), 'fig');

%% Plot coco & rest average time-course N = 17
cd('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/coco');

%Load the time courses + average across 17 subjects for coco
load('pupil_time_courses_coco_n17');
load('average_pupil_time_courses_coco_n17');

%Load the time courses + average across 17 subjects for rest 
load('pupil_time_courses_rest_n17'); 
load('average_pupil_time_courses_rest_n17');
 
fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
        
plot(average_pupil_time_courses_coco_n17_min10plus10(1,1:80000)); %Plot average coco power across 17 subjects in 1 line in 1 figure.
        xlim([0 80000])   %x = linspace(0,60000);
        xticks([0 10000 20000 30000 40000 50000 60000 70000 80000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-10','0','10','20','30','40','50','60','+10'})
        h = xline(10000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(70000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil diameter');
        title(['coco average time course (N = 17)']); 
    

        fig_name = ['coco_average_time_course_n17'];
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/coco',fig_name), 'jpg');
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/coco',fig_name), 'fig');

%hold on
plot(average_pupil_time_courses_rest_n17_min10plus10(1,1:80000)); %Plot average rest power across 17 subjects in 1 line in 1 figure.
%leg2 = legend('coco','rest');
%set(leg2, 'Position', [.6 .8 .11 .08], 'Color', [1 1 1],'FontSize',10);
 
 
        xlim([0 80000])   %x = linspace(0,60000);
        xticks([0 10000 20000 30000 40000 50000 60000 70000 80000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-10','0','10','20','30','40','50','60','+10'})
        h = xline(10000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(70000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil diameter');
        title(['rest average time course (N = 17)']); 
    

        fig_name = ['rest_average_time_course_n17'];
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/coco',fig_name), 'jpg');
        saveas(gcf, fullfile('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/coco',fig_name), 'fig');
 

%% boundedline toolbox for plotting the time-course COCO & TOS

%Reshape the data for plotting purposes
%coco
Pupil_time_courses_coco_n17_min10plus10 = Pupil_time_courses_coco_n17_min10plus10'; %pupil_time_courses_coco_n17 = pupil_time_courses_coco_n17';

%rest
Pupil_time_courses_rest_n17_min10plus10 = Pupil_time_courses_rest_n17_min10plus10'; %pupil_time_courses_rest_n17 = pupil_time_courses_rest_n17';



%Reshape the data for plotting purposes
%threat-rest
Pupil_time_courses_threat_rest_n17_min6plus6 = Pupil_time_courses_threat_rest_n17_min6plus6';
average_pupil_time_courses_threat_rest_n17_min6plus6 = average_pupil_time_courses_threat_rest_n17_min6plus6';
%threat-odd
Pupil_time_courses_threat_odd_n17_min6plus6 = Pupil_time_courses_threat_odd_n17_min6plus6';
average_pupil_time_courses_threat_odd_n17_min6plus6 = average_pupil_time_courses_threat_odd_n17_min6plus6';
%safe-rest
Pupil_time_courses_safe_rest_n17_min6plus6 = Pupil_time_courses_safe_rest_n17_min6plus6';
average_pupil_time_courses_safe_rest_n17_min6plus6 = average_pupil_time_courses_safe_rest_n17_min6plus6';
%safe-odd
Pupil_time_courses_safe_odd_n17_min6plus6 = Pupil_time_courses_safe_odd_n17_min6plus6';
average_pupil_time_courses_safe_odd_n17_min6plus6 = average_pupil_time_courses_safe_odd_n17_min6plus6';
%shock
Pupil_time_courses_shock_n17_min6plus6 = Pupil_time_courses_shock_n17_min6plus6';
average_pupil_time_courses_shock_n17_min6plus6 = average_pupil_time_courses_shock_n17_min6plus6';


clc; close all;
scsz = get(0,'ScreenSize');
pos1 = [scsz(3)/10  scsz(4)/10  scsz(3)/1.5  scsz(4)/1.5];
fig55 = figure(55);
set(fig55,'Renderer','OpenGL','Units','pixels','OuterPosition',pos1,'Color',[.95,.95,.95])
%-------------------------------------------------------------
 
 
%-------------------------------------------------------------
 
c1= [.9 .2 .2]; c2= [.2 .4 .6]; c3= [.4 .8 .4]; c4= [.6 .6 .6]; c5= [.01 .9 .01];
c11=[.9 .3 .3]; c22=[.3 .5 .7]; c33=[.5 .9 .5]; c44=[.7 .7 .7]; c55=[.01 .9 .01];
applered= [.9 .2 .2]; oceanblue= [.2 .4 .6]; neongreen = [.1 .9 .1];
liteblue = [.2 .9 .9]; hotpink=[.9 .1 .9]; c11 = 'none';
MSz = 7;
ax = [.10 .10 .85 .85];
%-------------------------------------------------------------
 
 
 
% Assuming each line represents the average of 3 columns of data...
 
% dataset1 : 55x3 (row x col) dataset
 
% dataset2 : 55x3 (row x col) dataset
 
 
%===========================================================%
 
% Massage Data
 
%===========================================================%
 
 
nSETS = 2; %2
rNcN = size(average_pupil_time_courses_threat_rest_n17_min6plus6);
DP_REP = size(average_pupil_time_courses_threat_odd_n17_min6plus6);
safe_rest = size(average_pupil_time_courses_safe_rest_n17_min6plus6);
safe_odd = size(average_pupil_time_courses_safe_odd_n17_min6plus6);
shock = size(average_pupil_time_courses_shock_n17_min6plus6);
AveOver = 1;
DATARATE = 1;
t = 1;
 
 
	%==============================================%
	MuDATA=average_pupil_time_courses_threat_rest_n17_min6plus6; repDATA=rNcN(2);
	%------------------------------
	Mu = mean(MuDATA,2)';       Sd = std(MuDATA,0,2)';      Se = Sd./sqrt(repDATA);
	y_Mu = Mu;                  x_Mu = 1:(size(y_Mu,2));    e_Mu = Se;
	xx_Mu = 1:0.1:max(x_Mu);
	yy_Mu = interp1(x_Mu,y_Mu,xx_Mu,'pchip');
	ee_Mu = interp1(x_Mu,e_Mu,xx_Mu,'pchip');
	p_Mu = polyfit(x_Mu,Mu,1);
	x2_Mu = 1:0.1:max(x_Mu);	y2_Mu = polyval(p_Mu,x2_Mu);
	XT_Mu = xx_Mu';				YT_Mu = yy_Mu';		ET_Mu = ee_Mu';
	%==============================================%
 
 
	%hax = axes('Position',ax);
 
[ph1, po1] = boundedline(XT_Mu,YT_Mu, ET_Mu,'cmap',c1,'alpha','transparency', 0.4);
	hold on
 
	%==============================================%
	MuDATA=average_pupil_time_courses_threat_odd_n17_min6plus6; repDATA=DP_REP(2);
	%------------------------------
	Mu = mean(MuDATA,2)';		Sd = std(MuDATA,0,2)';		Se = Sd./sqrt(repDATA);
	y_Mu = Mu;				x_Mu = 1:(size(y_Mu,2));	e_Mu = Se;
	xx_Mu = 1:0.1:max(x_Mu);
	 yy_Mu = spline(x_Mu,y_Mu,xx_Mu);	% ee_Mu = spline(x_Mu,e_Mu,xx_Mu);
	yy_Mu = interp1(x_Mu,y_Mu,xx_Mu,'pchip');
	ee_Mu = interp1(x_Mu,e_Mu,xx_Mu,'pchip');
	p_Mu = polyfit(x_Mu,Mu,1);
	x2_Mu = 1:0.1:max(x_Mu);	y2_Mu = polyval(p_Mu,x2_Mu);
	XT_Mu = xx_Mu';				YT_Mu = yy_Mu';		ET_Mu = ee_Mu';
	%==============================================%
 
[ph2, po2] = boundedline(XT_Mu,YT_Mu, ET_Mu,'cmap',c2,'alpha','transparency', 0.4);

%==============================================%
	MuDATA=average_pupil_time_courses_safe_rest_n17_min6plus6; repDATA=safe_rest(2);
	%------------------------------
	Mu = mean(MuDATA,2)';		Sd = std(MuDATA,0,2)';		Se = Sd./sqrt(repDATA);
	y_Mu = Mu;				x_Mu = 1:(size(y_Mu,2));	e_Mu = Se;
	xx_Mu = 1:0.1:max(x_Mu);
	 yy_Mu = spline(x_Mu,y_Mu,xx_Mu);	% ee_Mu = spline(x_Mu,e_Mu,xx_Mu);
	yy_Mu = interp1(x_Mu,y_Mu,xx_Mu,'pchip');
	ee_Mu = interp1(x_Mu,e_Mu,xx_Mu,'pchip');
	p_Mu = polyfit(x_Mu,Mu,1);
	x2_Mu = 1:0.1:max(x_Mu);	y2_Mu = polyval(p_Mu,x2_Mu);
	XT_Mu = xx_Mu';				YT_Mu = yy_Mu';		ET_Mu = ee_Mu';
	%==============================================%
 
[ph3, po3] = boundedline(XT_Mu,YT_Mu, ET_Mu,'cmap',c3,'alpha','transparency', 0.4);
hold on
%==============================================%
	MuDATA=average_pupil_time_courses_safe_odd_n17_min6plus6; repDATA=safe_odd(2);
	%------------------------------
	Mu = mean(MuDATA,2)';		Sd = std(MuDATA,0,2)';		Se = Sd./sqrt(repDATA);
	y_Mu = Mu;				x_Mu = 1:(size(y_Mu,2));	e_Mu = Se;
	xx_Mu = 1:0.1:max(x_Mu);
	 yy_Mu = spline(x_Mu,y_Mu,xx_Mu);	% ee_Mu = spline(x_Mu,e_Mu,xx_Mu);
	yy_Mu = interp1(x_Mu,y_Mu,xx_Mu,'pchip');
	ee_Mu = interp1(x_Mu,e_Mu,xx_Mu,'pchip');
	p_Mu = polyfit(x_Mu,Mu,1);
	x2_Mu = 1:0.1:max(x_Mu);	y2_Mu = polyval(p_Mu,x2_Mu);
	XT_Mu = xx_Mu';				YT_Mu = yy_Mu';		ET_Mu = ee_Mu';
	%==============================================%
 
[ph4, po4] = boundedline(XT_Mu,YT_Mu, ET_Mu,'cmap',c4,'alpha','transparency', 0.4);

%==============================================%
	%MuDATA=average_pupil_time_courses_shock_n17_min6plus6; repDATA=shock(2);
	%------------------------------
	%Mu = mean(MuDATA,2)';		Sd = std(MuDATA,0,2)';		Se = Sd./sqrt(repDATA);
	%y_Mu = Mu;				x_Mu = 1:(size(y_Mu,2));	e_Mu = Se;
	%xx_Mu = 1:0.1:max(x_Mu);
	% yy_Mu = spline(x_Mu,y_Mu,xx_Mu);	% ee_Mu = spline(x_Mu,e_Mu,xx_Mu);
	%yy_Mu = interp1(x_Mu,y_Mu,xx_Mu,'pchip');
	%ee_Mu = interp1(x_Mu,e_Mu,xx_Mu,'pchip');
	%p_Mu = polyfit(x_Mu,Mu,1);
	%x2_Mu = 1:0.1:max(x_Mu);	y2_Mu = polyval(p_Mu,x2_Mu);
	%XT_Mu = xx_Mu';				YT_Mu = yy_Mu';		ET_Mu = ee_Mu';
	%==============================================%
 
%[ph5, po5] = boundedline(XT_Mu,YT_Mu, ET_Mu,'cmap',c5,'alpha','transparency', 0.4);
%	    axis tight; hold on;
	
	leg2 = legend([ph3,ph4],{'safe-rest','safe-odd'});
set(leg2, 'Position', [.6 .8 .11 .08], 'Color', [1 1 1],'FontSize',10);
	
%leg1 = legend([ph1],{'avg pupil diameter'});
%    set(leg1, 'Position', [.15 .85 .11 .08], 'Color', [1 1 1],'FontSize',10);
 
	%------ Legend &amp; Tick Labels -------
	%if verLessThan('matlab', '8.3.1');
%		xt = roundn((get(gca,'XTick')).*AveOver*DATARATE.*(t)./(60),0);
%		set(gca,'XTickLabel', sprintf('%.0f|',xt))
%	else
%        hax2 = (get(gca));
%        hax2.XTick = ([0,10000,20000,30000,40000,50000,60000]);%
%		xt = hax2.XTick;%
%		xtt = roundn(xt*AveOver*DATARATE*(t)/(60),0);
%		hax2.XTickLabel = xtt;
%        hax2.XLim = ([0 60000]);%
%	end
	%------
 
 
        MS1 = 5; MS2 = 2; MS3 = 1; MS4 = 4;
   set(ph1,'LineStyle','-','Color',c1,'LineWidth',3,...
        'Marker','none','MarkerSize',MS1,'MarkerEdgeColor',c1);
   set(ph2,'LineStyle','-','Color',c2,'LineWidth',3,...
      'Marker','none','MarkerSize',MS1,'MarkerEdgeColor',c2);
   set(ph3,'LineStyle','-','Color',c3,'LineWidth',3,...
      'Marker','none','MarkerSize',MS1,'MarkerEdgeColor',c3);
   set(ph4,'LineStyle','-','Color',c4,'LineWidth',3,...
      'Marker','none','MarkerSize',MS1,'MarkerEdgeColor',c4);
   %set(ph5,'LineStyle','-','Color',c5,'LineWidth',3,...
   %   'Marker','none','MarkerSize',MS1,'MarkerEdgeColor',c5);
   
 
    hTitle  = title ('\fontsize{12} coco & rest average time-courses N = 17');
    hXLabel = xlabel('\fontsize{12} Time (ms)');
    hYLabel = ylabel('\fontsize{12} Pupil diameter (+/- SEM)');
    set(gca,'FontName','Helvetica','FontSize',12);
    set([hTitle, hXLabel, hYLabel],'FontName','Century Gothic');
    %set(gca,'Box','off','TickDir','out','TickLength',[.01 .01], ...
    %'XMinorTick','off','YMinorTick','on','YGrid','on', ...
    %'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',2);
 
    %------
    % Extra axis for boxing
    %haxes1 = gca; % handle to axes
	%haxes1_pos = get(haxes1,'Position'); % store position of first axes
	%haxes2 = axes('Position',haxes1_pos,'Color','none',...
%				  'XAxisLocation','top','YAxisLocation','right');
%	set(gca,'Box','off','TickDir','out','TickLength',[.01 .01], ...
%	'XMinorTick','off','YMinorTick','off','XGrid','off','YGrid','off', ...
%	'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',2, ...
 %   'XTick', [], 'YTick', []);
    %------
 
% for COCO    
        xlim([0 80000])   %x = linspace(0,60000);
        xticks([0 10000 20000 30000 40000 50000 60000 70000 80000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-10','0','10','20','30','40','50','60','+10'})
        h = xline(10000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(70000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil diameter (+/- SEM)');
        title(['coco average time courses (N = 17)']); 
        
 % for TOS
        xlim([0 72000])  %x = linspace(0,72000); %x = linspace(0,60000);
        xticks([0 6000 16000 26000 36000 46000 56000 66000 72000]) %xticks([0 10000 20000 30000 40000 50000 60000])
        xticklabels({'-6','0','10','20','30','40','50','60','+6'})
        h = xline(6000,'r','Trial onset'); %this line is added with the -10 + 10 range
        h1 = xline(66000,'r','Trial offset'); %this line is added with the -10 + 10 range
        xlabel('Time (s)');
        ylabel('Pupil diameter (mean)');
        title(['safe-rest & safe-odd average time courses (N = 17)']);
%===========================================================%
 
%%







%% FOR 2ND LEVEL SCRIPT %% %%%% coco %%%%%%
% Bar plot with individual data points
x=1:2;
means_bar_coco = mean(rest_safe_n17_log);
stdevs_bar_coco = std(rest_safe_n17_log);
stderror = stdevs_bar_coco/sqrt(17);

figure 
hold on
bar_handle = bar(x,means_bar_coco);
errorbar(means_bar_coco,stderror ,'.')
grid on
ylabel('Pupil dilation')
title('Pupil dilation rest vs. safe log (N = 17)')
XTickLabel={'rest';'safe'};
Ylim   =   get(gca,'ylim');
%Ylim([2000 7000])
Xlim  =   get(gca, 'xlim');
set(gca, 'XTick',x);
set(gca, 'XTickLabel', XTickLabel);
plot(x,rest_safe_n17_log(1,:),'o','Color','r')
plot(x,rest_safe_n17_log(2,:),'o','Color','b')
plot(x,rest_safe_n17_log(3,:),'o','Color','y')
plot(x,rest_safe_n17_log(4,:),'o','Color','g')
plot(x,rest_safe_n17_log(5,:),'o','Color','c')
plot(x,rest_safe_n17_log(6,:),'o','Color','m')
plot(x,rest_safe_n17_log(7,:),'o','Color','w')
plot(x,rest_safe_n17_log(8,:),'o','Color','k')
plot(x,rest_safe_n17_log(9,:),'o','Color','r')
plot(x,rest_safe_n17_log(10,:),'o','Color','b')
plot(x,rest_safe_n17_log(11,:),'o','Color','y')
plot(x,rest_safe_n17_log(12,:),'o','Color','g')
plot(x,rest_safe_n17_log(13,:),'o','Color','c')
plot(x,rest_safe_n17_log(14,:),'o','Color','m')
plot(x,rest_safe_n17_log(15,:),'o','Color','w')
plot(x,rest_safe_n17_log(16,:),'o','Color','k')
plot(x,rest_safe_n17_log(17,:),'o','Color','r')

plot([rest_safe_n17_log(1,1) rest_safe_n17_log(1,2)],'r');
plot([rest_safe_n17_log(2,1) rest_safe_n17_log(2,2)],'b');
plot([rest_safe_n17_log(3,1) rest_safe_n17_log(3,2)],'y');
plot([rest_safe_n17_log(4,1) rest_safe_n17_log(4,2)],'g');
plot([rest_safe_n17_log(5,1) rest_safe_n17_log(5,2)],'c');
plot([rest_safe_n17_log(6,1) rest_safe_n17_log(6,2)],'m');
plot([rest_safe_n17_log(7,1) rest_safe_n17_log(7,2)],'w');
plot([rest_safe_n17_log(8,1) rest_safe_n17_log(8,2)],'k');
plot([rest_safe_n17_log(9,1) rest_safe_n17_log(9,2)],'--r');
plot([rest_safe_n17_log(10,1) rest_safe_n17_log(10,2)],'--b');
plot([rest_safe_n17_log(11,1) rest_safe_n17_log(11,2)],'--y');
plot([rest_safe_n17_log(12,1) rest_safe_n17_log(12,2)],'--g');
plot([rest_safe_n17_log(13,1) rest_safe_n17_log(13,2)],'--c');
plot([rest_safe_n17_log(14,1) rest_safe_n17_log(14,2)],'--m');
plot([rest_safe_n17_log(15,1) rest_safe_n17_log(15,2)],'--w');
plot([rest_safe_n17_log(16,1) rest_safe_n17_log(16,2)],'--k');
plot([rest_safe_n17_log(17,1) rest_safe_n17_log(17,2)],'--r');

%% FOR 2ND LEVEL SCRIPT %% TOS


%%%%%% TOS %%%%%%
TOS_013_abs = TOS_013_abs';
% Bar plot with individual data points
x=1:9;

%means_bar = [];
means_bar = (TOS_013_abs);
%stdevs_bar = [];
stdevs_bar = std(TOS_n17_abs);
stderror = stdevs_bar/sqrt(17);


figure
hold on
bar_handle = bar(x,means_bar);
errorbar(means_bar,stderror ,'.')
grid on
ylabel('Pupil dilation')
title(' Pupil TOS abs values 013')
%XTickLabel={'Red-rest';'Red-odd';'Green-rest';'Green-odd';'shock'};
XTickLabel={'rf';'go';'ro';'gf';'rf';'gf';'sh';'ro';'go'}; %;'ro';'gf';'rf';'go';'ro';'go';'rf';'gf'};
Ylim   =   get(gca,'ylim');
Xlim  =   get(gca, 'xlim');
set(gca, 'XTick',x);
set(gca, 'XTickLabel', XTickLabel);
plot(x,TOS_mean_vector(:,1),'o','Color','r')
plot(x,TOS_mean_vector(:,2),'o','Color','b')
plot(x,TOS_mean_vector(:,3),'o','Color','y')
plot(x,TOS_mean_vector(:,4),'o','Color','g')
plot(x,TOS_mean_vector(:,5),'o','Color','c')
plot(x,TOS_mean_vector(:,6),'o','Color','m')
plot(x,TOS_mean_vector(:,7),'o','Color','w')
plot(x,TOS_mean_vector(:,8),'o','Color','k')
plot(x,TOS_mean_vector(:,9),'o','Color','r')
plot(x,TOS_mean_vector(:,10),'o','Color','b')
plot(x,TOS_mean_vector(:,11),'o','Color','y')
plot(x,TOS_013_abs(1,:),'o','Color','m')
plot(x,TOS_mean_vector(:,13),'o','Color','c')
plot(x,TOS_mean_vector(:,14),'o','Color','m')
plot(x,TOS_mean_vector(:,15),'o','Color','w')
plot(x,TOS_mean_vector(:,16),'o','Color','k')
plot(x,TOS_mean_vector(:,17),'o','Color','r')

%add lines to barplot points
plot([TOS_n17_abs(1,1) TOS_n17_abs(1,2) TOS_n17_abs(1,3) TOS_n17_abs(1,4) TOS_n17_abs(1,5)],'r');
plot([TOS_n17_abs(2,1) TOS_n17_abs(2,2) TOS_n17_abs(2,3) TOS_n17_abs(2,4) TOS_n17_abs(2,5)],'b');
plot([TOS_n17_abs(3,1) TOS_n17_abs(3,2) TOS_n17_abs(3,3) TOS_n17_abs(3,4) TOS_n17_abs(3,5)],'y');
plot([TOS_n17_abs(4,1) TOS_n17_abs(4,2) TOS_n17_abs(4,3) TOS_n17_abs(4,4) TOS_n17_abs(4,5)],'g');
plot([TOS_n17_abs(5,1) TOS_n17_abs(5,2) TOS_n17_abs(5,3) TOS_n17_abs(5,4) TOS_n17_abs(5,5)],'c');
plot([TOS_n17_abs(6,1) TOS_n17_abs(6,2) TOS_n17_abs(6,3) TOS_n17_abs(6,4) TOS_n17_abs(6,5)],'m');
plot([TOS_n17_abs(7,1) TOS_n17_abs(7,2) TOS_n17_abs(7,3) TOS_n17_abs(7,4) TOS_n17_abs(7,5)],'w');
plot([TOS_n17_abs(8,1) TOS_n17_abs(8,2) TOS_n17_abs(8,3) TOS_n17_abs(8,4) TOS_n17_abs(8,5)],'k');
plot([TOS_n17_abs(9,1) TOS_n17_abs(9,2) TOS_n17_abs(9,3) TOS_n17_abs(9,4) TOS_n17_abs(9,5)],'--r');
plot([TOS_n17_abs(10,1) TOS_n17_abs(10,2) TOS_n17_abs(10,3) TOS_n17_abs(10,4) TOS_n17_abs(10,5)],'--b');
plot([TOS_n17_abs(11,1) TOS_n17_abs(11,2) TOS_n17_abs(11,3) TOS_n17_abs(11,4) TOS_n17_abs(11,5)],'--y');
plot([TOS_n17_abs(12,1) TOS_n17_abs(12,2) TOS_n17_abs(12,3) TOS_n17_abs(12,4) TOS_n17_abs(12,5)],'--g');
plot([TOS_n17_abs(13,1) TOS_n17_abs(13,2) TOS_n17_abs(13,3) TOS_n17_abs(13,4) TOS_n17_abs(13,5)],'--c');
plot([TOS_n17_abs(14,1) TOS_n17_abs(14,2) TOS_n17_abs(14,3) TOS_n17_abs(14,4) TOS_n17_abs(14,5)],'--m');
plot([TOS_n17_abs(15,1) TOS_n17_abs(15,2) TOS_n17_abs(15,3) TOS_n17_abs(15,4) TOS_n17_abs(15,5)],'--w');
plot([TOS_n17_abs(16,1) TOS_n17_abs(16,2) TOS_n17_abs(16,3) TOS_n17_abs(16,4) TOS_n17_abs(16,5)],'--k');
plot([TOS_n17_abs(17,1) TOS_n17_abs(17,2) TOS_n17_abs(17,3) TOS_n17_abs(17,4) TOS_n17_abs(17,5)],'--r');


%% PREVIOUS TEST SCRIPTS %%
% Put all the average thr_fix, thr_odd, safe_fix, safe_odd, shock values in 5 variables for average N = 17 time-course plotting and save pupil values time courses threat-rest (data)
%cd('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/TOS/-6+6');

%Load the time course + average across 17 subjects for threat-rest
%load('Pupil_time_courses_threat_rest_n17_min6plus6.mat');                      %load('Pupil_time_courses_threat_rest_n17.mat');
%load('average_pupil_time_courses_threat_rest_n17_min6plus6');

%Pupil_time_courses_threat_rest_n17_min6plus6(17,1:72001) = TOS_thr_fix_average; %Pupil_time_courses_threat_rest_n17(1,1:60001) = TOS_thr_fix_average;
%save('Pupil_time_courses_threat_rest_n17_min6plus6.mat','Pupil_time_courses_threat_rest_n17_min6plus6') %save('Pupil_time_courses_threat_rest_n17.mat','Pupil_time_courses_threat_rest_n17')

%Load the time course + average across 17 subjects for threat-odd
%load('Pupil_time_courses_threat_odd_n17_min6plus6.mat');                        %load('Pupil_time_courses_threat_odd_n17.mat');
%load('average_pupil_time_courses_threat_odd_n17_min6plus6');


%Pupil_time_courses_threat_odd_n17_min6plus6(17,1:72001) = TOS_thr_odd_average;  %Pupil_time_courses_threat_odd_n17(1,1:60001) = TOS_thr_odd_average;
%save('Pupil_time_courses_threat_odd_n17_min6plus6.mat','Pupil_time_courses_threat_odd_n17_min6plus6') %save('Pupil_time_courses_threat_odd_n17.mat','Pupil_time_courses_threat_odd_n17')

%Load the time course + average across 17 subjects for safe-rest
%load('Pupil_time_courses_safe_rest_n17_min6plus6.mat');   
%load('average_pupil_time_courses_safe_rest_n17_min6plus6');

%Pupil_time_courses_safe_rest_n17_min6plus6(17,1:72001) = TOS_safe_fix_average;  %Pupil_time_courses_safe_rest_n17(1,1:60001) = TOS_thr_safe_average;
%save('Pupil_time_courses_safe_rest_n17_min6plus6.mat','Pupil_time_courses_safe_rest_n17_min6plus6') %save('Pupil_time_courses_safe_rest_n17.mat','Pupil_time_courses_safe_rest_n17')

%Load the time course + average across 17 subjects for safe-odd
%load('Pupil_time_courses_safe_odd_n17_min6plus6.mat');    
%load('average_pupil_time_courses_safe_odd_n17_min6plus6');

%load('Pupil_time_courses_safe_odd_n17.mat');
%Pupil_time_courses_safe_odd_n17_min6plus6(17,1:72001) = TOS_safe_odd_average;   %Pupil_time_courses_safe_odd_n17(1,1:60001) = TOS_safe_odd_average;
%save('Pupil_time_courses_safe_odd_n17_min6plus6.mat','Pupil_time_courses_safe_odd_n17_min6plus6') %save('Pupil_time_courses_safe_odd_n17.mat','Pupil_time_courses_safe_odd_n17')

%Load the time course + average across 17 subjects for shock
%load('Pupil_time_courses_shock_n17_min6plus6.mat');  
%load('average_pupil_time_courses_shock_n17_min6plus6');


%load('Pupil_time_courses_shock_n17.mat');
%Pupil_time_courses_shock_n17_min6plus6(17,1:72001) = TOS_shock_average;         %Pupil_time_courses_shock_n17(1,1:60001) = TOS_shock_average;
%save('Pupil_time_courses_shock_n17_min6plus6.mat','Pupil_time_courses_shock_n17_min6plus6') %save('Pupil_time_courses_shock_n17.mat','Pupil_time_courses_shock_n17')

%% Plot TOS average time-courses N = 17


%Calculate the average across 17 subjects for threat-rest
%average_pupil_time_courses_threat_rest_n17_min6plus6 = mean(Pupil_time_courses_threat_rest_n17_min6plus6(1:17,1:72001)); %average_pupil_time_courses_threat_rest_n17 = mean(Pupil_time_courses_threat_rest_n17(1:17,1:60001));
%save('average_pupil_time_courses_threat_rest_n17_min6plus6.mat','average_pupil_time_courses_threat_rest_n17_min6plus6')  %save('average_pupil_time_courses_threat_rest_n17.mat','average_pupil_time_courses_threat_rest_n17')

%Calculate the average across 17 subjects for threat-odd
%average_pupil_time_courses_threat_odd_n17_min6plus6 = mean(Pupil_time_courses_threat_odd_n17_min6plus6(1:17,1:72001)); %average_pupil_time_courses_threat_odd_n17 = mean(Pupil_time_courses_threat_odd_n17(1:17,1:60001));
%save('average_pupil_time_courses_threat_odd_n17_min6plus6.mat','average_pupil_time_courses_threat_odd_n17_min6plus6')  %save('average_pupil_time_courses_threat_odd_n17.mat','average_pupil_time_courses_threat_odd_n17')

%Calculate the average across 17 subjects for safe-rest
%average_pupil_time_courses_safe_rest_n17_min6plus6 = mean(Pupil_time_courses_safe_rest_n17_min6plus6(1:17,1:72001)); %average_pupil_time_courses_safe_rest_n17 = mean(Pupil_time_courses_safe_rest_n17(1:17,1:60001));
%save('average_pupil_time_courses_safe_rest_n17_min6plus6.mat','average_pupil_time_courses_safe_rest_n17_min6plus6')  %save('average_pupil_time_courses_safe_rest_n17.mat','average_pupil_time_courses_safe_rest_n17')

%Calculate the average across 17 subjects for safe-odd
%average_pupil_time_courses_safe_odd_n17_min6plus6 = mean(Pupil_time_courses_safe_odd_n17_min6plus6(1:17,1:72001)); %average_pupil_time_courses_safe_odd_n17 = mean(Pupil_time_courses_safe_odd_n17(1:17,1:60001));
%save('average_pupil_time_courses_safe_odd_n17_min6plus6.mat','average_pupil_time_courses_safe_odd_n17_min6plus6')  %save('average_pupil_time_courses_safe_odd_n17.mat','average_pupil_time_courses_safe_odd_n17')

%Calculate the average across 17 subjects for shock
%average_pupil_time_courses_shock_n17_min6plus6 = mean(Pupil_time_courses_shock_n17_min6plus6(1:17,1:72001)); %average_pupil_time_courses_shock_n17 = mean(Pupil_time_courses_shock_n17(1:17,1:60001));
%save('average_pupil_time_courses_shock_n17_min6plus6.mat','average_pupil_time_courses_shock_n17_min6plus6')  %save('average_pupil_time_courses_shock_n17.mat','average_pupil_time_courses_shock_n17') 

%% Plot coco & rest average time-course N = 17
%cd('/project/3024005.01/Analysis/Pupil/Results/group-level (60 sec)/coco');

%Load the time courses + average across 17 subjects for coco
%load('Pupil_time_courses_coco_n17_min10plus10');
%load('average_pupil_time_courses_coco_n17_min10plus10');
%average_pupil_time_courses_coco_n17_min10plus10 = mean(Pupil_time_courses_coco_n17_min10plus10(1:17,1:80001));
 
%Load the time courses + average across 17 subjects for rest 
%load('Pupil_time_courses_rest_n17_min10plus10'); 
%load('average_pupil_time_courses_rest_n17_min10plus10');
%average_pupil_time_courses_rest_n17_min10plus10 = mean(Pupil_time_courses_rest_n17_min10plus10(1:17,1:80001));