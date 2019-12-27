%% Pupil Labs eye-tracking data
% This code can be utilized after the data has been pre-processed with
% Interpol.

% Jordy van Langen
% December 2019
% e-mail: jordy.vanlangen@sydney.edu.au

%% Initialize

subject = '001'; %%%%% specify subject number

clc; close all; clearvars -except subject; %%%%% make sure to have a clean workspace

%% create correct path, add functions and scripts
restoredefaultpath;
addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
addpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil');

%% Define input directory and files
conf.input.rawdir = '/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil';
conf.input.matdir = fullfile(pf_findfile(conf.input.rawdir,['/' subject '/'],'fullfile'));

% For the left eye .mat file
conf.input.matfile_L = pf_findfile(conf.input.matdir,['/' subject '_pupil_positions_recoded_left.mat/'],'fullfile'); 

%For the right eye .mat file
conf.input.matfile_R = pf_findfile(conf.input.matdir,['/' subject '_pupil_positions_recoded_right.mat/'],'fullfile'); 

%Add the annotations file for trial offsets 
conf.input.onsetsfile_L = pf_findfile(conf.input.matdir,['/' subject '_stimOnsets_L.mat/'], 'fullfile');
conf.input.onsetsfile_R = pf_findfile(conf.input.matdir,['/' subject '_stimOnsets_R.mat/'], 'fullfile');

%% Define where saved data and figures are stored 
conf.output.dir = [ '/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/001/results'];
conf.output.figdir = [ '/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/001/results/Figures' ];
conf.output.datadir = [ '/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/001/results/Data' ];
conf.output.save = 'yes';
if ~exist(conf.output.dir)
    mkdir(conf.output.dir);
end

if ~exist(conf.output.figdir)
    mkdir(conf.output.figdir);
end

if ~exist(conf.output.datadir)
    mkdir(conf.output.datadir);
end

%% Load the files (.mat = interpoldat & .csv = annotations)

%%%% Make sure to only load the left_eye OR only the right_eye interpol dataframe

%Left eye dataframe
filename_interpoldat = conf.input.matfile_L;
load(filename_interpoldat);

%Right eye dataframe
%filename_interpoldat = conf.input.matfile_R;
%load(filename_interpoldat);

% On and offsets dataframe left eye
filename_onsets = conf.input.onsetsfile_L;
load(filename_onsets);

% On and offsets data
%filename_onsets = conf.input.onsetsfile_R;
%load(filename_onsets);

%% Define what you want to analyse from variables pupdat and interpoldat 
conf.ana.var     =  {
%                      'Raw X';
%                      'Raw Y';
                       'Pupil';}; % pupdat.names you want to analyse (e.g. Pupil)


conf.ana.type    =  'fullinterpoldat'; % field saved in interpoldat that you want to plot
conf.ana.check   =  {
%                       'all';
                        'usable';
%                       'non-usable';
                        }; % Indicate if you want to use data that has been marked usable, non-usable, indeterminate or all            

%% Select the data to analyse 
nVar = length(conf.ana.var); %the amount of variables analyzed
CurVar = conf.ana.var; %the name of the current variable that is analyzed
fullinterpoldat  = interpoldat.(conf.ana.type); %indicates the fullinterpoldat structure that will be used for plotting    

%%% Get the onset
%%onset  = pupdat.trialonsets{1, 3}; %onset of trials for pupil as defined in pupdat.trialonset
%%offset = pupdat.trialonsets{1, 3} + 60*pupdat.samplerate; % offset of trials for pupil 
%%nOns    = length(onset); %get the number of onsets

%% Sort the trial codes in the following order
% threat-low    : 70
% threat-high   : 71
% safe-low      : 80
% safe-high     : 81
% shock         : 128

[sorted_trials, indeces_trials] = sort(pupdat.trialcodes{1,3});

%% Put the offsets in column 2 in the stimOnsets variable
stimOnsets_L(35:51,1) = stimOnsets_L(2:2:34,1);
stimOnsets_L(2:2:34,1) = NaN;
stimOnsets_L = rmmissing(stimOnsets_L);
stimOnsets_L(1:17,2) = stimOnsets_L(18:34,1);
stimOnsets_L(18:34,1) = NaN;
stimOnsets_L(18:34,2) = NaN;
stimOnsets_L = rmmissing(stimOnsets_L);

%% Add the trial codes as a 3rd column to the stimOnsets data frame
stimOnsets_L(:,3) = pupdat.trialcodes{1,3};

%% Sort the onsets according to the sorted trial codes (70, 71, 80, 81, 128).
stimOnsets_L = sortrows(stimOnsets_L, 3);

%% Split and combine the individual trials in seperate data frames according to the onsets and offsets 

%% Threat_low
%Create prefilled dataframe with 0s
trial_threat_low_df = zeros(10000,5);

%Determine the amount of rows
t1 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(1,1):stimOnsets_L(1,2)));
t2 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(2,1):stimOnsets_L(2,2)));
t3 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(3,1):stimOnsets_L(3,2)));
t4 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(4,1):stimOnsets_L(4,2)));

%Fill in the trial columns + 5th column added to calculate average pupil
%diameter accross trials
trial_threat_low_df(t1,1) = fullinterpoldat{1, 3}(stimOnsets_L(1,1):stimOnsets_L(1,2));
trial_threat_low_df(t2,2) = fullinterpoldat{1, 3}(stimOnsets_L(2,1):stimOnsets_L(2,2));
trial_threat_low_df(t3,3) = fullinterpoldat{1, 3}(stimOnsets_L(3,1):stimOnsets_L(3,2));
trial_threat_low_df(t4,4) = fullinterpoldat{1, 3}(stimOnsets_L(4,1):stimOnsets_L(4,2));

%Fill the 0s with NaN
trial_threat_low_df(trial_threat_low_df == 0) = NaN;

%Calculate mean + SD of each trial in column 5 with the function nanmean and nanstd
trial_threat_low_df(1:4,5) = nanmean(trial_threat_low_df(:,1:4));
trial_threat_low_df(1:4,6) = nanstd(trial_threat_low_df(:,1:4));

%Calculate the mean of the trial means
trial_threat_low_df(1,7) = mean(trial_threat_low_df(1:4,5));
trial_threat_low_df(2,7) = std(trial_threat_low_df(1:4,5));

%Save the mean + SD threat-low
if strcmp(conf.output.save,'yes')
    threat_low_statistics = trial_threat_low_df;
    save(fullfile(conf.output.datadir,[ subject '_threat_low_statistics']),'threat_low_statistics');
end


%% Threat_high
trial_threat_high_df = zeros(10000,5);

%Determine the amount of rows
t5 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(5,1):stimOnsets_L(5,2)));
t6 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(6,1):stimOnsets_L(6,2)));
t7 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(7,1):stimOnsets_L(7,2)));
t8 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(8,1):stimOnsets_L(8,2)));

%Fill in the trial columns + 5th column added to calculate average pupil
%diameter accross trials
trial_threat_high_df(t5,1) = fullinterpoldat{1, 3}(stimOnsets_L(5,1):stimOnsets_L(5,2));
trial_threat_high_df(t6,2) = fullinterpoldat{1, 3}(stimOnsets_L(6,1):stimOnsets_L(6,2));
trial_threat_high_df(t7,3) = fullinterpoldat{1, 3}(stimOnsets_L(7,1):stimOnsets_L(7,2));
trial_threat_high_df(t8,4) = fullinterpoldat{1, 3}(stimOnsets_L(8,1):stimOnsets_L(8,2));

%Fill the 0s with NaN
trial_threat_high_df(trial_threat_high_df == 0) = NaN;

%Calculate mean + SD of each trial in column 5 with the function nanmean and nanstd
trial_threat_high_df(1:4,5) = nanmean(trial_threat_high_df(:,1:4));
trial_threat_high_df(1:4,6) = nanstd(trial_threat_high_df(:,1:4));

%Calculate the mean of the trial means
trial_threat_high_df(1,7) = mean(trial_threat_high_df(1:4,5));
trial_threat_high_df(2,7) = std(trial_threat_high_df(1:4,5));

%Save the mean + SD threat-high
if strcmp(conf.output.save,'yes')
    threat_high_statistics = trial_threat_high_df;
    save(fullfile(conf.output.datadir,[ subject '_threat_high_statistics']),'threat_high_statistics');
end


%% Safe_low
trial_safe_low_df = zeros(10000,5);

%Determine the amount of rows
t9 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(9,1):stimOnsets_L(9,2)));
t10 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(10,1):stimOnsets_L(10,2)));
t11 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(11,1):stimOnsets_L(11,2)));
t12 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(12,1):stimOnsets_L(12,2)));

%Fill in the trial columns + 5th column added to calculate average pupil
%diameter accross trials
trial_safe_low_df(t9,1) = fullinterpoldat{1, 3}(stimOnsets_L(9,1):stimOnsets_L(9,2));
trial_safe_low_df(t10,2) = fullinterpoldat{1, 3}(stimOnsets_L(10,1):stimOnsets_L(10,2));
trial_safe_low_df(t11,3) = fullinterpoldat{1, 3}(stimOnsets_L(11,1):stimOnsets_L(11,2));
trial_safe_low_df(t12,4) = fullinterpoldat{1, 3}(stimOnsets_L(12,1):stimOnsets_L(12,2));

%Fill the 0s with NaN
trial_safe_low_df(trial_safe_low_df == 0) = NaN;

%Calculate mean + SD of each trial in column 5 with the function nanmean and nanstd
trial_safe_low_df(1:4,5) = nanmean(trial_safe_low_df(:,1:4));
trial_safe_low_df(1:4,6) = nanstd(trial_safe_low_df(:,1:4));

%Calculate the mean of the trial means
trial_safe_low_df(1,7) = mean(trial_safe_low_df(1:4,5));
trial_safe_low_df(2,7) = std(trial_safe_low_df(1:4,5));

%Save the mean + SD threat-low
if strcmp(conf.output.save,'yes')
    safe_low_statistics = trial_safe_low_df;
    save(fullfile(conf.output.datadir,[ subject '_safe_low_statistics']),'safe_low_statistics');
end

%% Safe_high
trial_safe_high_df = zeros(10000,5);

%Determine the amount of rows
t13 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(13,1):stimOnsets_L(13,2)));
t14 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(14,1):stimOnsets_L(14,2)));
t15 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(15,1):stimOnsets_L(15,2)));
t16 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(16,1):stimOnsets_L(16,2)));

%Fill in the trial columns + 5th column added to calculate average pupil
%diameter accross trials
trial_safe_high_df(t13,1) = fullinterpoldat{1, 3}(stimOnsets_L(13,1):stimOnsets_L(13,2));
trial_safe_high_df(t14,2) = fullinterpoldat{1, 3}(stimOnsets_L(14,1):stimOnsets_L(14,2));
trial_safe_high_df(t15,3) = fullinterpoldat{1, 3}(stimOnsets_L(15,1):stimOnsets_L(15,2));
trial_safe_high_df(t16,4) = fullinterpoldat{1, 3}(stimOnsets_L(16,1):stimOnsets_L(16,2));

%Fill the 0s with NaN
trial_safe_high_df(trial_safe_high_df == 0) = NaN;

%Calculate mean + SD of each trial in column 5 with the function nanmean and nanstd
trial_safe_high_df(1:4,5) = nanmean(trial_safe_high_df(:,1:4));
trial_safe_high_df(1:4,6) = nanstd(trial_safe_high_df(:,1:4));

%Calculate the mean of the trial means
trial_safe_high_df(1,7) = mean(trial_safe_high_df(1:4,5));
trial_safe_high_df(2,7) = std(trial_safe_high_df(1:4,5));

%Save the mean + SD threat-low
if strcmp(conf.output.save,'yes')
    safe_high_statistics = trial_safe_high_df;
    save(fullfile(conf.output.datadir,[ subject '_safe_high_statistics']),'safe_high_statistics');
end


%% Shock
trial_shock_df = zeros(10000,1);

%Determine the amount of rows
t17 = 1:length(fullinterpoldat{1, 3}(stimOnsets_L(17,1):stimOnsets_L(17,2)));

%Fill in the trial columns + 5th column added to calculate average pupil
%diameter accross trials
trial_shock_df(t17,1) = fullinterpoldat{1, 3}(stimOnsets_L(17,1):stimOnsets_L(17,2));

%Fill the 0s with NaN
trial_shock_df(trial_shock_df == 0) = NaN;

%Calculate the mean + SD
trial_shock_df(1,2) = nanmean(trial_shock_df(:,1));
trial_shock_df(2,2) = nanstd(trial_shock_df(:,1));

%Save the mean + SD threat-low
if strcmp(conf.output.save,'yes')
    shock_statistics = trial_shock_df;
    save(fullfile(conf.output.datadir,[ subject '_shock_statistics']),'shock_statistics');
end

%% Put it all in one dataframe
TOS_mean_vector = [trial_threat_low_df(:,1:4), trial_threat_high_df(:,1:4), trial_safe_low_df(:,1:4), trial_safe_high_df(:,1:4), trial_shock_df(:,1)];
TOS_mean_vector = TOS_mean_vector';

%% TOS %% Time-course plotting of pupil data 

TOS_mean_vector = [trial_threat_low_df(:,1:4), trial_threat_high_df(:,1:4), trial_safe_low_df(:,1:4), trial_safe_high_df(:,1:4), trial_shock_df(:,1)];
TOS_mean_vector = TOS_mean_vector';

TOS_threat_low_average = mean(TOS_mean_vector(1:4,:));
TOS_threat_high_average = mean(TOS_mean_vector(5:8,:));
TOS_safe_low_average = mean(TOS_mean_vector(9:12,:));
TOS_safe_high_average = mean(TOS_mean_vector(13:16,:));
TOS_shock_average = (TOS_mean_vector(17,:));

TOS_conditions = {TOS_threat_low_average,TOS_threat_high_average,TOS_safe_low_average,TOS_safe_high_average,TOS_shock_average };

%% Threat-low
conditions = { 'threat-low'};
for condition=1:length(conditions)
    
    fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
    hold on
    plot(TOS_conditions{1,1}(:,:)); 
    title([subject ' threat-low ']);
    xlabel('Time(s)');
    ylabel('pupil dilation (pixels)');
end 

%Save the plot
if strcmp(conf.output.save,'yes')
        fig_name = [ subject '_threat_low_time_course' ];
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'jpg');
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'fig');
end
        
%Save the pupil values time courses threat-low 
if strcmp(conf.output.save,'yes')
    threat_low_time_course = TOS_mean_vector(1:4,:); 
    save(fullfile(conf.output.datadir,[ subject '_threat_low_time_course']),'threat_low_time_course'); 
end

%Save the average pupil values time course threat-low 
if strcmp(conf.output.save,'yes')
    average_threat_low_time_course = TOS_conditions{1,1}(:,:); 
    save(fullfile(conf.output.datadir,[ subject '_average_threat_low_time_course']),'average_threat_low_time_course'); 
end

%% Threat-high
conditions = { 'threat-high'};
for condition=1:length(conditions)
    
    fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
    hold on
    plot(TOS_conditions{1,2}(:,:)); 
    title([subject ' threat-high ']);
    xlabel('Time(s)');
    ylabel('pupil dilation (pixels)');
end 

%Save the plot
if strcmp(conf.output.save,'yes')
        fig_name = [ subject '_threat_high_time_course' ];
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'jpg');
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'fig');
end
        
%Save the pupil values time courses threat-high
if strcmp(conf.output.save,'yes')
    threat_high_time_course = TOS_mean_vector(5:8,:); 
    save(fullfile(conf.output.datadir,[ subject '_threat_high_time_course']),'threat_high_time_course'); 
end

%Save the average pupil values time course threat-high 
if strcmp(conf.output.save,'yes')
    average_threat_high_time_course = TOS_conditions{1,2}(:,:); 
    save(fullfile(conf.output.datadir,[ subject '_average_threat_high_time_course']),'average_threat_high_time_course'); 
end
%% Safe-low
conditions = { 'safe-low'};
for condition=1:length(conditions)
    
    fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
    hold on
    plot(TOS_conditions{1,3}(:,:)); 
    title([subject ' safe-low ']);
    xlabel('Time(s)');
    ylabel('pupil dilation (pixels)');
end 

%Save the plot
if strcmp(conf.output.save,'yes')
        fig_name = [ subject '_safe_low_time_course' ];
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'jpg');
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'fig');
end
        
%Save the pupil values time courses threat-high
if strcmp(conf.output.save,'yes')
    safe_low_time_course = TOS_mean_vector(9:12,:); 
    save(fullfile(conf.output.datadir,[ subject '_safe_low_time_course']),'safe_low_time_course'); 
end

%Save the average pupil values time course threat-high 
if strcmp(conf.output.save,'yes')
    average_safe_low_time_course = TOS_conditions{1,3}(:,:); 
    save(fullfile(conf.output.datadir,[ subject '_average_safe_low_time_course']),'average_safe_low_time_course'); 
end


%% Safe-high
conditions = { 'safe-high'};
for condition=1:length(conditions)
    
    fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
    hold on
    plot(TOS_conditions{1,4}(:,:)); 
    title([subject ' safe-high ']);
    xlabel('Time(s)');
    ylabel('pupil dilation (pixels)');
end 

%Save the plot
if strcmp(conf.output.save,'yes')
        fig_name = [ subject '_safe_high_time_course' ];
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'jpg');
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'fig');
end
        
%Save the pupil values time courses threat-high
if strcmp(conf.output.save,'yes')
    safe_high_time_course = TOS_mean_vector(13:16,:); 
    save(fullfile(conf.output.datadir,[ subject '_safe_high_time_course']),'safe_high_time_course'); 
end

%Save the average pupil values time course threat-high 
if strcmp(conf.output.save,'yes')
    average_safe_high_time_course = TOS_conditions{1,4}(:,:); 
    save(fullfile(conf.output.datadir,[ subject '_average_safe_high_time_course']),'average_safe_high_time_course'); 
end

%% Shock
conditions = { 'shock'};
for condition=1:length(conditions)
    
    fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
    hold on
    plot(TOS_conditions{1,5}(:,:)); 
    title([subject ' shock ']);
    xlabel('Time(s)');
    ylabel('pupil dilation (pixels)');
end 

%Save the plot
if strcmp(conf.output.save,'yes')
        fig_name = [ subject '_shock_time_course' ];
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'jpg');
        saveas(gcf, fullfile(conf.output.figdir,fig_name), 'fig');
end
        
%Save the pupil values time courses threat-high
if strcmp(conf.output.save,'yes')
    shock_time_course = TOS_mean_vector(17,:); 
    save(fullfile(conf.output.datadir,[ subject '_shock_time_course']),'shock_time_course'); 
end

%Save the average pupil values time course threat-high 
if strcmp(conf.output.save,'yes')
    average_shock_time_course = TOS_conditions{1,5}(:,:); 
    save(fullfile(conf.output.datadir,[ subject '_average_shock_time_course']),'average_shock_time_course'); 
end

%% TO DO %%

% - Create code that plots the timeseries of the 4 trials in 1 figure
fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
hold on
plot(TOS_conditions{1,1}(:,:),'b-');
hold on
plot(TOS_conditions{1,2}(:,:), 'r-');
plot(TOS_conditions{1,3}(:,:), 'g-');
plot(TOS_conditions{1,4}(:,:), 'y-');
title([subject ' All conditions ']);
xlabel('Time(s)');
ylabel('pupil dilation (pixels)');
legend('threat-low','threat-high','safe-low','safe-high');
hold off

% - extract .mat dataframe to .csv (try timeseries plotting in python) -> seaborn

        % FileData = load('FileName.mat');
        % csvwrite('FileName.csv', FileData.M);


% - How to make each timecourse equal (i.e. fill in NaNs). 


% - How to identify time series of pupil respones before Freezing (e.g., -6, onset, during, and
% after 

 



%Calculate the average across 17 subjects for threat-rest
average_pupil_time_courses_threat_rest_n17 = mean(pupil_time_courses_threat_rest_n17);
save('average_pupil_time_courses_threat_rest_n17.mat','average_pupil_time_courses_threat_rest_n17') 

%Calculate the average across 17 subjects for threat-rest
average_pupil_time_courses_threat_odd_n17 = mean(pupil_time_courses_threat_odd_n17);
save('average_pupil_time_courses_threat_odd_n17.mat','average_pupil_time_courses_threat_odd_n17') 

%Calculate the average across 17 subjects for threat-rest
average_pupil_time_courses_safe_rest_n17 = mean(pupil_time_courses_safe_rest_n17);
save('average_pupil_time_courses_safe_rest_n17.mat','average_pupil_time_courses_safe_rest_n17') 

%Calculate the average across 17 subjects for threat-rest
average_pupil_time_courses_safe_odd_n17 = mean(pupil_time_courses_safe_odd_n17);
save('average_pupil_time_courses_safe_odd_n17.mat','average_pupil_time_courses_safe_odd_n17') 

%Calculate the average across 17 subjects for threat-rest
average_pupil_time_courses_shock_n17 = mean(pupil_time_courses_shock_n17);
save('average_pupil_time_courses_shock_n17.mat','average_pupil_time_courses_shock_n17') 
