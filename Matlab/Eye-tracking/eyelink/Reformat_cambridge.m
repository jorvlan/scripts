% Use this script to get the eyelink data from Cambridge
% into the format that is needed for the interpol conversion script

% Jordy van Langen
% March 2020
% e-mail: jordy.vanlangen@sydney.edu.au

%% The script is fully automized, but only needs 3 manual changes:

% 1. Define `subject` as `cn` or `pd`
% 2. Specify conf.subject_csv{} depending on which subject you analyse
% 3. Specify conf.subject{} depending on which subject you analyse

% In order to use this script, you'll need to be connected to the
% 'fs2.shared.sydney.edu.au' network of The University of Sydney

%% Define subject

subject = 'cn'; %change this to 'pd' if analyzing PD patients

if strcmp(subject, 'cn')
    
    conf.subject = {'cn_001', 'cn_002', 'cn_003','cn_004', 'cn_006', 'cn_007', 'cn_008', 'cn_009', 'cn_010',...
       'cn_011', 'cn_012', 'cn_013', 'cn_014', 'cn_015', 'cn_016', 'cn_017', 'cn_018', 'cn_019',...
       'cn_020', 'cn_021', 'cn_022', 'cn_023', 'cn_024', 'cn_025', 'cn_026'};
   
    conf.subject_csv = {'cn_001.csv', 'cn_002.csv', 'cn_003.csv', 'cn_004.csv', 'cn_006.csv', 'cn_007.csv', 'cn_008.csv', 'cn_009.csv', 'cn_010.csv',...
       'cn_011.csv', 'cn_012.csv', 'cn_013.csv', 'cn_014.csv', 'cn_015.csv', 'cn_016.csv', 'cn_017.csv', 'cn_018.csv', 'cn_019.csv',...
       'cn_020.csv', 'cn_021.csv', 'cn_022.csv', 'cn_023.csv', 'cn_024.csv', 'cn_025.csv', 'cn_026.csv'};

elseif strcmp(subject, 'pd')
    
    conf.subject = {'pd_001_1', 'pd_001_2', 'pd_002_1','pd_002_2', 'pd_003_1', 'pd_003_2', 'pd_004_1', 'pd_004_2', 'pd_005_1',...
       'pd_005_2', 'pd_006_1', 'pd_006_2', 'pd_008_1', 'pd_008_2', 'pd_009_1', 'pd_009_2', 'pd_010_1', 'pd_010_2',...
       'pd_012_1', 'pd_012_2', 'pd_013_1', 'pd_014_1', 'pd_014_2', 'pd_015_1', 'pd_015_2', 'pd_016_1', 'pd_016_2',...
       'pd_017_1', 'pd_017_2', 'pd_018_1', 'pd_018_2', 'pd_019_1', 'pd_019_2', 'pd_020_1', 'pd_020_2'};
   
    conf.subject_csv = {'pd_001_1.csv', 'pd_001_2.csv', 'pd_002_1.csv','pd_002_2.csv', 'pd_003_1.csv', 'pd_003_2.csv', 'pd_004_1.csv', 'pd_004_2.csv', 'pd_005_1.csv',...
       'pd_005_2.csv', 'pd_006_1.csv', 'pd_006_2.csv', 'pd_008_1.csv', 'pd_008_2.csv', 'pd_009_1.csv', 'pd_009_2.csv', 'pd_010_1.csv', 'pd_010_2.csv',...
       'pd_012_1.csv', 'pd_012_2.csv', 'pd_013_1.csv', 'pd_014_1.csv', 'pd_014_2.csv', 'pd_015_1.csv', 'pd_015_2.csv', 'pd_016_1.csv', 'pd_016_2.csv',...
       'pd_017_1.csv', 'pd_017_2.csv', 'pd_018_1.csv', 'pd_018_2.csv', 'pd_019_1.csv', 'pd_019_2.csv', 'pd_020_1.csv', 'pd_020_2.csv'};
end
   
%% Preparation
    
    clc;
    clearvars -except conf subject
    restoredefaultpath;
    addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
    addpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/Reformatting_Preprocessing_Scripts/interpol_cambridge');
    
%% Configuration of directories with subject specific information
    
    conf.datadir = '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/eyelink_cambridge/';
    conf.datafile = pf_findfile(conf.datadir, conf.subject_csv{1},'fullfile'); %Change the {} number depending on the subject
    conf.outputfile = [ conf.datadir, conf.subject{1}, '_recoded.txt' ]; %Change the {} number depending on the subject
    
%% Load data

    filename = conf.datafile;
    delimiter = {','};
    formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
    fclose(fileID);
    dataframe = [dataArray{1:end}];
    
    % Clear temporary variables
    clearvars filename delimiter formatSpec fileID dataArray ans;

    %Create a column marking the start and end of the baseline recording.
    dataframe(:,17) = '1';
    dataframe(1,17) = 'Triggers';
    
    % Remove columns depending on whether the right or left eye was recorded
    j = [11, 10, 9, 8, 7];
    h = [16, 15, 14, 13, 12];
    
    if dataframe(2,6) == "Right"
            dataframe(:,j) = [];
    elseif dataframe(2,6) == "Left"
            dataframe(:,h) = [];
    end
    
    
    % Replace all '.' values with 0.0
    for i=1:length(dataframe)
        
       if strcmp(dataframe(i,7), '.')
           dataframe(i,7) = {'0.0'};
       end
       
       if strcmp(dataframe(i,8), '.')
           dataframe(i,8) = {'0.0'};
       end
       
       if strcmp(dataframe(i,11), '.')
           dataframe(i,11) = {'0.0'};
       end
       
    end
%% Save the adjusted dataframe

    fid = fopen(conf.outputfile, 'wt');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n', dataframe(:,1:12)');
    fclose(fid);
  