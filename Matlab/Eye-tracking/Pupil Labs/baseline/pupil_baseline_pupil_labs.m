%% Pupil Labs eye-tracking data
% This code can be utilized after the data has been pre-processed with
% Interpol.

% Jordy van Langen
% March 2020
% e-mail: jordy.vanlangen@sydney.edu.au

%% The script is fully automized, but only needs 3 manual changes:

% 1. Define conf.eye_recorded as `right` or `left`
% 2. Specify conf.subject{} depending on which subject you analyse
% 3. Specify conf.mat_file{} depending on which subject you analyse

% In order to use this script, you'll need to be connected to the
% 'fs2.shared.sydney.edu.au' network of The University of Sydney

%% Initialize

    conf.subject = {'001', '002', '003', '004', '005'}; %%%%% specify subject number
    conf.mat_file = {'pupil_positions_r.mat', 'pupil_positions_l.mat'};
    conf.eye_recorded = {'right'}; %change to 'left' if left eye.

%% create correct path, add functions and scripts
    clc;
    close all;
    clearvars -except conf
    restoredefaultpath;
    addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
    addpath(['/Volumes/BMRI/CRU/Parkinsons/Jordy/data/' conf.subject{1} '/seated_vr/pupil/baseline/tv/exports/000/']);

%% Define input directory and files
    conf.input.matdir = ['/Volumes/BMRI/CRU/Parkinsons/Jordy/data/' conf.subject{1} '/seated_vr/pupil/baseline/tv/exports/000/'];
    conf.input.matfile = pf_findfile(conf.input.matdir,conf.mat_file{2},'fullfile'); 
    conf.output.dir = [ '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/' conf.subject{1} '/seated_vr/pupil/baseline/tv/exports/000/'];
    conf.output.save = 'yes';

%% Load the data
    filename_interpoldat = conf.input.matfile;
    load(filename_interpoldat);

%Extract the fullinterpoldat structure
    conf.ana.type    =  'fullinterpoldat';
    fullinterpoldat  = interpoldat.(conf.ana.type);

    norm_pos_x = fullinterpoldat{1};
    norm_pos_y = fullinterpoldat{2};
    diameter = fullinterpoldat{3};
    diameter_3d = fullinterpoldat{4};

    fullinterpoldat_df = [norm_pos_x, norm_pos_y, diameter, diameter_3d];

%% Plot interpolated data to compare in notebook
    fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
    subplot(2,1,1), plot(fullinterpoldat{1,3}(:,:));
        xlabel('Time(s)');
        ylabel('pupil dilation (pixels)');
        title('Interpolated signal 2D model');
        
    subplot(2,1,2), plot(fullinterpoldat{1,4}(:,:)); 
        xlabel('Time(s)');
        ylabel('pupil dilation (mm)');
        title('Interpolated signal 3D model ');
%% Save the data again as .csv

if strcmp(conf.eye_recorded, 'right')
        if strcmp(conf.output.save,'yes')
            csvwrite([conf.output.dir 'fullinterpoldat_df_r.csv'], fullinterpoldat_df);
        end
end

if strcmp(conf.eye_recorded, 'left')
        if strcmp(conf.output.save,'yes')
            csvwrite([conf.output.dir 'fullinterpoldat_df_l.csv'], fullinterpoldat_df);
        end
end