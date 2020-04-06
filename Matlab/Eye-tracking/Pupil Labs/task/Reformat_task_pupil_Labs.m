% Use this script to get Pupil Labs data into the format that is needed for
% the interpol conversion script

% Jordy van Langen
% March 2020
% e-mail: jordy.vanlangen@sydney.edu.au

%% The script is fully automized, but only needs 3 manual changes:

% 1. Define conf.subject_csv{} as pupil_positions_r.csv or pupil_positions_l.csv
% 2. Specify conf.subject{} as (1, 2, 3, 4, or 5) depending on which subject you analyse
% 3. Specify conf.block{} as (1, 2, 3, or 4) depending on which block you
% analyse

% In order to use this script, you'll need to be connected to the
% 'fs2.shared.sydney.edu.au' network of The University of Sydney

%% Define subject information

conf.subject = {'001', '002', '003', '004', '005'};

conf.subject_csv = {'pupil_positions_l.csv'}; %change to pupil_positions_l.csv for left eye

conf.block = {'block1', 'block2', 'block3', 'block4'};
block = 'block1'; %'block2' 'block3' 'block4'

    %% Preparation
    clc;
    clearvars -except conf block
    restoredefaultpath;
    addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
    addpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/Reformatting_Preprocessing_Scripts/interpol_pupillabs');
    
    %% Configuration with subject specific information

    %General settings
    conf.rawdir = '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/';
    conf.analysisdir = [conf.rawdir conf.subject{2} '/seated_vr/pupil/task/' conf.block{1} '/exports/000/'];
    conf.annotationsfile = pf_findfile(conf.analysisdir,'/annotations.csv/','fullfile');
    
    %Settings for right or left eye
if strcmp(conf.subject_csv, 'pupil_positions_r.csv')
    conf.pupillabsfile = pf_findfile(conf.analysisdir,'/pupil_positions_r.csv/','fullfile');
    conf.outputfile_right = [ conf.analysisdir, 'pupil_positions_recoded_r.txt' ];
    conf.outputfile_onsets_R = [ conf.analysisdir, 'stimOnsets_R.mat' ];
    
elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
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
    clearvars filename delimiter formatSpec fileID dataArray ans
    

    %Create a column containing the events.
    TOS(:,35) = '0.0';
    TOS(1,35) = 'Triggers';
    
    % All cells with < .6 confidence replace with '0.0'.
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

%% Put in the trial codes from the annotations file in the trigger column
    % Safe_low = 80;
    % Safe_high = 81;
    % Threat_low = 70;
    % Threat_high = 71;

if strcmp(block, 'block1')
    
    for i = 1:length(TOS(:,2))
        
        %Safe_low
        if TOS(i,2) == TOS_annotations(2,1)
            TOS(i,35) = {'80'};
        elseif TOS(i,2) == TOS_annotations(3,1)
            TOS(i,35) = {'80'};
        end
        
        %Threat_high
        if TOS(i,2) == TOS_annotations(4,1)
            TOS(i,35) = {'71'};
        elseif TOS(i,2) == TOS_annotations(5,1)
            TOS(i,35) = {'71'};
        end
            
        %Safe_high
        if TOS(i,2) == TOS_annotations(6,1)
            TOS(i,35) = {'81'};
        elseif TOS(i,2) == TOS_annotations(7,1)
            TOS(i,35) = {'81'};
        end
          
        %Threat_low
        if TOS(i,2) == TOS_annotations(8,1)
            TOS(i,35) = {'70'};
        elseif TOS(i,2) == TOS_annotations(9,1)
            TOS(i,35) = {'70'};
        end
       
    end
    
elseif strcmp(block, 'block2') 
    
    for i = 1:length(TOS(:,2))
        
        %threat-high -> shock code is 128, but 001 had no 4th threat block
        %and received no shock so here 71.
        if TOS(i,2) == TOS_annotations(2,1)
            TOS(i,35) = {'71'};
        elseif TOS(i,2) == TOS_annotations(3,1)
            TOS(i,35) = {'71'};
        end
        
        %threat-high
        if TOS(i,2) == TOS_annotations(4,1)
            TOS(i,35) = {'71'};
        elseif TOS(i,2) == TOS_annotations(5,1)
            TOS(i,35) = {'71'};
        end
            
        %safe-low
        if TOS(i,2) == TOS_annotations(6,1)
            TOS(i,35) = {'80'};
        elseif TOS(i,2) == TOS_annotations(7,1)
            TOS(i,35) = {'80'};
        end
          
        %safe-high
        if TOS(i,2) == TOS_annotations(8,1)
            TOS(i,35) = {'81'};
        elseif TOS(i,2) == TOS_annotations(9,1)
            TOS(i,35) = {'81'};
        end
        
        %threat-low
        if TOS(i,2) == TOS_annotations(10,1)
            TOS(i,35) = {'70'};
        elseif TOS(i,2) == TOS_annotations(11,1)
            TOS(i,35) = {'70'};
        end
       
    end
    
elseif strcmp(block, 'block3')    

    for i = 1:length(TOS(:,2))
        
        %Threat_low
        if TOS(i,2) == TOS_annotations(2,1)
            TOS(i,35) = {'70'};
        elseif TOS(i,2) == TOS_annotations(3,1)
            TOS(i,35) = {'70'};
        end
        
        %Safe_high
        if TOS(i,2) == TOS_annotations(4,1)
            TOS(i,35) = {'81'};
        elseif TOS(i,2) == TOS_annotations(5,1)
            TOS(i,35) = {'81'};
        end
            
        %Safe_low
        if TOS(i,2) == TOS_annotations(6,1)
            TOS(i,35) = {'80'};
        elseif TOS(i,2) == TOS_annotations(7,1)
            TOS(i,35) = {'80'};
        end
          
        %Threat_high
        if TOS(i,2) == TOS_annotations(8,1)
            TOS(i,35) = {'71'};
        elseif TOS(i,2) == TOS_annotations(9,1)
            TOS(i,35) = {'71'};
        end
       
    end
    
elseif strcmp(block, 'block4')
    
    for i = 1:length(TOS(:,2))
        
        %Threat_low
        if TOS(i,2) == TOS_annotations(2,1)
            TOS(i,35) = {'81'};
        elseif TOS(i,2) == TOS_annotations(3,1)
            TOS(i,35) = {'81'};
        end
        
        %Safe_high
        if TOS(i,2) == TOS_annotations(4,1)
            TOS(i,35) = {'70'};
        elseif TOS(i,2) == TOS_annotations(5,1)
            TOS(i,35) = {'70'};
        end
            
        %Safe_low
        if TOS(i,2) == TOS_annotations(6,1)
            TOS(i,35) = {'80'};
        elseif TOS(i,2) == TOS_annotations(7,1)
            TOS(i,35) = {'80'};
        end
          
 
    %Threat_high
        if TOS(i,2) == TOS_annotations(8,1)
            TOS(i,35) = {'71'};
        elseif TOS(i,2) == TOS_annotations(9,1)
            TOS(i,35) = {'71'};
        end
       
    end
  
end

%Assign the stimonsets to a variable that will be saved later
if strcmp(conf.subject_csv, 'pupil_positions_r.csv')
    stimOnsets_R_t = find(diff(TOS(:,35)>"1")>0)+1;
elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
    stimOnsets_L_t = find(diff(TOS(:,35)>"1")>0)+1;
end
  
    %% Check whether all on and offsets are present, otherwise fill in.

if exist ('stimOnsets_R_t', 'var')
    
    if length(stimOnsets_R_t) < 8
    disp('There are less than 8 onsets')
    onset1 = find(TOS(:,2)==TOS_annotations(2,1)); 
    offset1 = find(TOS(:,2)==TOS_annotations(3,1));
    onset2 = find(TOS(:,2)==TOS_annotations(4,1));
    offset2 = find(TOS(:,2)==TOS_annotations(5,1));
    onset3 = find(TOS(:,2)==TOS_annotations(6,1)); 
    offset3 = find(TOS(:,2)==TOS_annotations(7,1));
    onset4 = find(TOS(:,2)== TOS_annotations(8,1)); % '18582' -> 001, block1 - R
    offset4 = find(TOS(:,2)==TOS_annotations(9,1));
    stimOnsets_R = [onset1(1,1), offset1(1,1), onset2(1,1), offset2(1,1), onset3(1,1), offset3(1,1), onset4(1,1), offset4(1,1)];
    stimOnsets_R = stimOnsets_R';
    elseif length(stimOnsets_R_t) == 8
        
        disp('There were 8 onsets found')
  
    else
        
       disp('No stimOnsets_R')
        
    end 
    
elseif exist('stimOnsets_L_t', 'var')
    
    if length(stimOnsets_L_t) < 8
    disp('There are less than 8 onsets, search index onset in TOS and change TOS_annotations')
    onset1 = find(TOS(:,2)==TOS_annotations(2,1)); 
    offset1 = find(TOS(:,2)==TOS_annotations(3,1));
    onset2 = find(TOS(:,2)==TOS_annotations(4,1));
    offset2 = find(TOS(:,2)==TOS_annotations(5,1));
    onset3 = find(TOS(:,2)==TOS_annotations(6,1)); 
    offset3 = find(TOS(:,2)==TOS_annotations(7,1));
    onset4 = find(TOS(:,2)== TOS_annotations(8,1)); % '18582' -> 001, block1 - R
    offset4 = find(TOS(:,2)==TOS_annotations(9,1));
    
    stimOnsets_L = [onset1(1,1), offset1(1,1), onset2(1,1), offset2(1,1), onset3(1,1), offset3(1,1), onset4(1,1), offset4(1,1)];
    stimOnsets_L = stimOnsets_L';
    elseif length(stimOnsets_L_t) == 8
        disp('There were 8 onsets found')
    else 
        disp('No stimOnsets_L')
        
    end
end
    

   


    %% Fill in the empty space between the on and off-set markers as indicated by their index number.


if strcmp(block, 'block1')
    
   if strcmp(conf.subject_csv, 'pupil_positions_r.csv')
    
   TOS(stimOnsets_R(1,1):stimOnsets_R(2,1),35) = '80';
   TOS(stimOnsets_R(3,1):stimOnsets_R(4,1),35) = '71';
   TOS(stimOnsets_R(5,1):stimOnsets_R(6,1),35) = '81';
   TOS(stimOnsets_R(7,1):stimOnsets_R(8,1),35) = '70';
   
   elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
       
   TOS(stimOnsets_L(1,1):stimOnsets_L(2,1),35) = '80';
   TOS(stimOnsets_L(3,1):stimOnsets_L(4,1),35) = '71';
   TOS(stimOnsets_L(5,1):stimOnsets_L(6,1),35) = '81';
   TOS(stimOnsets_L(7,1):stimOnsets_L(8,1),35) = '70';
   
   end
   
elseif strcmp(block, 'block2') 
   
   if strcmp(conf.subject_csv, 'pupil_positions_r.csv')
  
   TOS(stimOnsets_R(1,1):stimOnsets_R(2,1),35) = '71';
   TOS(stimOnsets_R(3,1):stimOnsets_R(4,1),35) = '71';
   TOS(stimOnsets_R(5,1):stimOnsets_R(6,1),35) = '80';
   TOS(stimOnsets_R(7,1):stimOnsets_R(8,1),35) = '81';
   TOS(stimOnsets_R(9,1):stimOnsets_R(10,1),35) = '71';
   
   elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
       
   TOS(stimOnsets_L(1,1):stimOnsets_L(2,1),35) = '71';
   TOS(stimOnsets_L(3,1):stimOnsets_L(4,1),35) = '71';
   TOS(stimOnsets_L(5,1):stimOnsets_L(6,1),35) = '80';
   TOS(stimOnsets_L(7,1):stimOnsets_L(8,1),35) = '81';
   TOS(stimOnsets_L(9,1):stimOnsets_L(10,1),35) = '71';
   
   end
 
elseif strcmp(block, 'block3') 

   if strcmp(conf.subject_csv, 'pupil_positions_r.csv')
   
   TOS(stimOnsets_R(1,1):stimOnsets_R(2,1),35) = '70';
   TOS(stimOnsets_R(3,1):stimOnsets_R(4,1),35) = '81';
   TOS(stimOnsets_R(5,1):stimOnsets_R(6,1),35) = '80';
   TOS(stimOnsets_R(7,1):stimOnsets_R(8,1),35) = '71';
   
   elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
   
   TOS(stimOnsets_L(1,1):stimOnsets_L(2,1),35) = '70';
   TOS(stimOnsets_L(3,1):stimOnsets_L(4,1),35) = '81';
   TOS(stimOnsets_L(5,1):stimOnsets_L(6,1),35) = '80';
   TOS(stimOnsets_L(7,1):stimOnsets_L(8,1),35) = '71';
   
   end
   
 
elseif strcmp(block, 'block4')

   if strcmp(conf.subject_csv, 'pupil_positions_r.csv')
   TOS(stimOnsets_R(1,1):stimOnsets_R(2,1),35) = '81';
   TOS(stimOnsets_R(3,1):stimOnsets_R(4,1),35) = '70';
   TOS(stimOnsets_R(5,1):stimOnsets_R(6,1),35) = '81';
   TOS(stimOnsets_R(7,1):stimOnsets_R(8,1),35) = '70';
   
   elseif strcmp(conf.subject_csv, 'pupil_positions_l.csv')
       
   TOS(stimOnsets_L(1,1):stimOnsets_L(2,1),35) = '81';
   TOS(stimOnsets_L(3,1):stimOnsets_L(4,1),35) = '70';
   TOS(stimOnsets_L(5,1):stimOnsets_L(6,1),35) = '81';
   TOS(stimOnsets_L(7,1):stimOnsets_L(8,1),35) = '70'; 
   end
   
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