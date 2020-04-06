% Use this script to get Pupil Labs data into the format that is needed for
% the interpol conversion script

% Jordy van Langen
% March 2020
% e-mail: jordy.vanlangen@sydney.edu.au

%% The script is fully automized, but only needs 2 manual changes:

% 1. Define conf.subject_csv{} as pupil_positions_r.csv or pupil_positions_l.csv
% 2. Specify conf.subject{} twice depending on which subject you analyse

% In order to use this script, you'll need to be connected to the
% 'fs2.shared.sydney.edu.au' network of The University of Sydney
%% Define subject

conf.subject = {'001', '002', '003', '004', '005'};

conf.subject_csv = {'pupil_positions_l.csv'}; %change to pupil_positions_l.csv for left eye

 %% Preparation
    clc;
    clearvars -except conf 
    restoredefaultpath;
    addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
    addpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/Reformatting_Preprocessing_Scripts/interpol_pupillabs');

  %% 
if strcmp(conf.subject_csv, 'pupil_positions_r.csv')

    conf.rawdir = '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/';
    conf.analysisdir = [conf.rawdir conf.subject{5} '/seated_vr/pupil/baseline/tv/exports/000/'];
    conf.annotationsfile = pf_findfile(conf.analysisdir,'/annotations.csv/','fullfile');
    conf.pupillabsfile = pf_findfile(conf.analysisdir,'/pupil_positions_r.csv/','fullfile');
    conf.outputfile_right = [ conf.analysisdir, 'pupil_positions_recoded_r.txt' ];
    conf.outputfile_onsets_R = [ conf.analysisdir, 'stimOnsets_R.mat' ];

elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
    
    conf.rawdir = '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/';
    conf.analysisdir = [conf.rawdir conf.subject{5} '/seated_vr/pupil/baseline/tv/exports/000/'];
    conf.annotationsfile = pf_findfile(conf.analysisdir,'/annotations.csv/','fullfile');
    conf.pupillabsfile = pf_findfile(conf.analysisdir,'/pupil_positions_l.csv/','fullfile');
    conf.outputfile_left = [ conf.analysisdir, 'pupil_positions_recoded_l.txt' ];
    conf.outputfile_onsets_L = [ conf.analysisdir, 'stimOnsets_L.mat' ];
    
end
    
    %% Load data
    filename = conf.pupillabsfile;
    delimiter = ',';
    formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
    fclose(fileID);
   
    TOS = [dataArray{1:end-1}];
    % Clear temporary variables
    clearvars filename delimiter formatSpec fileID dataArray ans;

    %% Add the markers from annotations.csv
    filename = conf.annotationsfile;
    delimiter = ',';
    formatSpec = '%s%s%s%s%s%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
    fclose(fileID);
    
    TOS_annotations = [dataArray{1:end}];
    % Clear temporary variables
    clearvars filename delimiter formatSpec fileID dataArray ans;
    

    %Create a column containing the events.
    TOS(:,35) = '0.0';
    TOS(1,35) = 'Triggers';
    
    %All cells with < .6 confidence replace with '0.0'.
for i = 2:length(TOS)
      if TOS(i,4) < {'0.6'}
            TOS(i,5:7) = {'0.0'};
      elseif TOS(i,4) < {'0.6'}
            TOS(i,14) = {'0.0'};
      end
end
    
    
for i = 2:length(TOS)
      if TOS(i,15) < {'0.6'}
            TOS(i,14) = {'0.0'};
      end
end
    
    %Assign trigger values to the recorded time
for i = 1:length(TOS(:,2))
        
      if TOS(i,2) == TOS_annotations(2,1)
            TOS(i,35) = {'10'};
      elseif TOS(i,2) == TOS_annotations(3,1)
            TOS(i,35) = {'10'};
      end
end

%Assign trigger values depending on right or left eye
if strcmp(conf.subject_csv, 'pupil_positions_r.csv')
    stimOnsets_R = find(diff(TOS(:,35)>"1")>0)+1;
    TOS(stimOnsets_R(1,1):stimOnsets_R(2,1),35) = '10';
    
elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
    stimOnsets_L = find(diff(TOS(:,35)>"1")>0)+1;
    TOS(stimOnsets_L(1,1):stimOnsets_L(2,1),35) = '10';
    
end


    %% Now that the trigger markers are set, we can remove all unneccesary columns
   
    
  for i = [34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15]
        TOS(:,i) = [];
  end
    
  for i = [13, 12, 11, 10, 9, 8]
        TOS(:,i) = [];
  end
    
        TOS(:,3) = [];
    
    %% Save the adjusted string array without all the messages
    
if strcmp(conf.subject_csv, 'pupil_positions_r.csv')
    
    fid = fopen(conf.outputfile_right, 'wt');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n', TOS(:,1:8)');
    fclose(fid);
    save(fullfile(conf.analysisdir, 'stimOnsets_R'));
    
elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
    

    fid = fopen(conf.outputfile_left, 'wt');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n', TOS(:,1:8)');
    fclose(fid);
    save(fullfile(conf.analysisdir, 'stimOnsets_L'));
end
