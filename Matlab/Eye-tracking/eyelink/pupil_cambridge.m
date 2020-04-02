%% Cambridge eye-tracking data
% This code can be utilized after the data has been pre-processed with
% the Interpol toolbox.

% Jordy van Langen
% March 2020
% e-mail: jordy.vanlangen@sydney.edu.au

%% The script is fully automized, but only needs 3 manual changes:

% 1. Define `subject` as `cn` or `pd`
% 2. Specify conf.subject{} depending on which subject you analyse
% 3. Specify conf.mat_file{} depending on which subject you analyse

% In order to use this script, you'll need to be connected to the
% 'fs2.shared.sydney.edu.au' network of The University of Sydney

%% Define subject

  subject = 'cn'; %change this to 'pd' if analyzing PD patients

if strcmp(subject, 'cn')
    
    conf.subject = {
       'cn_001', 'cn_002', 'cn_003','cn_004', 'cn_006', 'cn_007', 'cn_008', 'cn_009', 'cn_010',...
       'cn_011', 'cn_012', 'cn_013', 'cn_014', 'cn_015', 'cn_016', 'cn_017', 'cn_018', 'cn_019',...
       'cn_020', 'cn_021', 'cn_022', 'cn_023', 'cn_024', 'cn_025', 'cn_026'};
   
    conf.mat_file = {
       'cn_001_recoded.mat', 'cn_002_recoded.mat', 'cn_003_recoded.mat','cn_004_recoded.mat',...
       'cn_006_recoded.mat', 'cn_007_recoded.mat', 'cn_008_recoded.mat', 'cn_009_recoded.mat', 'cn_010_recoded.mat',...
       'cn_011_recoded.mat', 'cn_012_recoded.mat', 'cn_013_recoded.mat', 'cn_014_recoded.mat', 'cn_015_recoded.mat',...
       'cn_016_recoded.mat', 'cn_017_recoded.mat', 'cn_018_recoded.mat', 'cn_019_recoded.mat', 'cn_020_recoded.mat', 'cn_021_recoded.mat',...
       'cn_022_recoded.mat', 'cn_023_recoded.mat', 'cn_024_recoded.mat', 'cn_025_recoded.mat', 'cn_026_recoded.mat'};

elseif strcmp(subject, 'pd')
    
     conf.subject = {
       'pd_001_1', 'pd_001_2', 'pd_002_1','pd_002_2', 'pd_003_1', 'pd_003_2', 'pd_004_1', 'pd_004_2', 'pd_005_1',...
       'pd_005_2', 'pd_006_1', 'pd_006_2', 'pd_008_1', 'pd_008_2', 'pd_009_1', 'pd_009_2', 'pd_010_1', 'pd_010_2',...
       'pd_012_1', 'pd_012_2', 'pd_013_1', 'pd_014_1', 'pd_014_2', 'pd_015_1', 'pd_015_2', 'pd_016_1', 'pd_016_2',...
       'pd_017_1', 'pd_017_2', 'pd_018_1', 'pd_018_2', 'pd_019_1', 'pd_019_2', 'pd_020_1', 'pd_020_2'};

    
    conf.matfile_ = {
       'pd_001_1_recoded.mat', 'pd_001_2_recoded.mat', 'pd_002_1_recoded.mat','pd_002_2_recoded.mat',...
       'pd_003_1_recoded.mat', 'pd_003_2_recoded.mat', 'pd_004_1_recoded.mat', 'pd_004_2_recoded.mat',...
       'pd_005_1_recoded.mat', 'pd_005_2_recoded.mat', 'pd_006_1_recoded.mat', 'pd_006_2_recoded.mat',...
       'pd_008_1_recoded.mat', 'pd_008_2_recoded.mat', 'pd_009_1_recoded.mat', 'pd_009_2_recoded.mat',... 
       'pd_010_1_recoded.mat', 'pd_010_2_recoded.mat', 'pd_012_1_recoded.mat', 'pd_012_2_recoded.mat',...
       'pd_013_1_recoded.mat', 'pd_014_1_recoded.mat', 'pd_014_2_recoded.mat', 'pd_015_1_recoded.mat',...
       'pd_015_2_recoded.mat', 'pd_016_1_recoded.mat', 'pd_016_2_recoded.mat', 'pd_017_1_recoded.mat',...
       'pd_017_2_recoded.mat', 'pd_018_1_recoded.mat', 'pd_018_2_recoded.mat', 'pd_019_1_recoded.mat',...
       'pd_019_2_recoded.mat', 'pd_020_1_recoded.mat', 'pd_020_2_recoded.mat'};
end 



%% create correct path, add functions and scripts
    
    clc;
    close all;
    clearvars -except subject conf
    restoredefaultpath;
    addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
    addpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/data/eyelink_cambridge');

%% Define input, output directory, select file and specifiy whether to save the data.
   
    conf.input.matdir   = '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/eyelink_cambridge';
    conf.input.matfile  = pf_findfile(conf.input.matdir,conf.mat_file{1},'fullfile'); 
    conf.output.dir     = '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/eyelink_cambridge/';
    conf.output.save    = 'yes';

%% Load the data

    filename_interpoldat = conf.input.matfile;
    load(filename_interpoldat);

    % Extract the fullinterpoldat structure and put into a variable
    conf.ana.type      =  'fullinterpoldat';
    fullinterpoldat    = interpoldat.(conf.ana.type);
    diameter           = fullinterpoldat{1};
    fullinterpoldat_df = diameter;
    
%% Plot interpolated signal for inspection and compare with non-interpolated raw signal
   
    fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
    subplot(2,1,1), plot(pupdat.rawdat{1}(:));
        xlabel('Time(s)');
        ylabel('pupil dilation (pixels)');
        title('Raw non-interpolated signal');
        
    subplot(2,1,2), plot(fullinterpoldat{1,1}(:,:)); 
        xlabel('Time(s)');
        ylabel('pupil dilation (pixels)');
        title('Interpolated signal');

%% Save the data again as .csv

    if strcmp(conf.output.save,'yes')
        csvwrite([conf.output.dir conf.subject{1} '_fullinterpoldat.csv'], fullinterpoldat_df);
    end
