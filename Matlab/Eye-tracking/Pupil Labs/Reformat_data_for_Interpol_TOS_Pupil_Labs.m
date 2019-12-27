
% Use this script to get Pupil Labs data into the format that is needed for
% the interpol conversion script
subjects = {'001'};

for index=1:length(subjects)

    %% Preparation
    clc;
    clearvars -except subjects index
    restoredefaultpath;
    addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
    %addpath(genpath('Z:/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
    
    %% Configuration with subject specific information
    conf.subject = subjects{index};
    conf.rawdir = '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/';
    %conf.rawdir = 'Z:/CRU/Parkinsons/Jordy/data/';
    conf.analysisdir = '/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil';
    
    
    % find complete filename using: fullfile(fpath,fname)
    conf.pupillabsdir = fullfile(pf_findfile(conf.rawdir,['/' conf.subject '/' ],'fullfile'),[conf.subject '_pupil']);
    conf.pupillabsfile = pf_findfile(conf.pupillabsdir,'/pupil_positions.csv/','fullfile');
    conf.annotationsfile = pf_findfile(conf.pupillabsdir,'/annotations.csv/','fullfile');
    conf.outputfile_left = [ conf.pupillabsdir '/' conf.subject '_pupil_positions_recoded_left.txt' ];
    conf.outputfile_right = [ conf.pupillabsdir '/' conf.subject '_pupil_positions_recoded_right.txt' ];
    conf.outputfile_onsets_L = [ conf.analysisdir '/' conf.subject '/' conf.subject '_stimOnsets_L.mat' ];
    conf.outputfile_onsets_R = [ conf.analysisdir '/' conf.subject '/' conf.subject '_stimOnsets_R.mat' ];
    
    %% Load data
    filename = conf.pupillabsfile;
    delimiter = ',';
    formatSpec = '%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
    fclose(fileID);
    
    TOS = [dataArray{1:end-1}];
    % Clear temporary variables
    clearvars filename delimiter formatSpec fileID dataArray ans;
    
    %% Remove columns that are unused 
    TOS(:, 10) = [];
    TOS(:, 9) = [];
    TOS(:, 8) = [];
    %TOS(:, 2) = [];
    
    %% Add the markers from annotations.csv
    filename = conf.annotationsfile;
    delimiter = ',';
    formatSpec = '%s%s%s%s%s%s%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
    fclose(fileID);
    
    TOS_annotations = [dataArray{1:end-1}];
    % Clear temporary variables
    clearvars filename delimiter formatSpec fileID dataArray ans;
    
    %% Add annotations in to the trigger column
    % Remove columns from annotations.csv that are unused 
    TOS_annotations(:, 6) = [];
    TOS_annotations(:, 5) = [];
    TOS_annotations(:, 4) = [];
    %Remove header row from annotations.csv
    TOS_annotations(1, :) = [];
    %% This approach is not advisible for the blink-removal algorithm, because it removes some trials with e.g. < .95 conf interval. This will otherwise be filtered out by the algorithm, which will include all trials! 
    %%% Filter out < % 95 confidence of pupil measurement.
    %TOS_high_conf = TOS(TOS(:, 3) >= '0.95', :);
    
    %% Split the pupil data into left and right eye data frames.
    TOS_left_eye_df = TOS(TOS(:, 3) == '1', :);
    TOS_right_eye_df = TOS(TOS(:, 3) == '0', :);

    %%% Split the pupil data from left and right eye.
    %sorted_by_id = sortrows(TOS, 3);
    
    %Export a new data frame which only contains left-eye pupil values
    %left_eye_df = sorted_by_id(any(sorted_by_id == '1',2),:);
    %Remove columns that are not used anymore
    TOS_left_eye_df(:, 4) = []; 
    TOS_left_eye_df(:, 3) = [];
    TOS_left_eye_df(:, 6) = '0.0'; %Add this string '0.0' for later conversion into the interpol structure
    
    %Export a new data frame which only contains right-eye pupil values
    %right_eye_df = sorted_by_id(any(sorted_by_id == '0',2),:);
    %Remove columns that are not used anymore
    TOS_right_eye_df(:, 4) = [];
    TOS_right_eye_df(:, 3) = [];
    TOS_right_eye_df(:, 6) = '0.0'; %Add this string '0.0' for later conversion into the interpol structure
    
    %Create header lines again in 
    left_eye_df_headers = ["Time", "Index", "Raw X", "Raw Y", "Pupil", "Triggers"];
    right_eye_df_headers = ["Time", "Index", "Raw X", "Raw Y", "Pupil", "Triggers"];
    
    %Add header lines to string data frames
    TOS_left_eye_df = [left_eye_df_headers; TOS_left_eye_df];
    TOS_right_eye_df = [right_eye_df_headers; TOS_right_eye_df];
    
    %Delete some unnecessary variables used above
    clearvars TOS_high_conf right_eye_df_headers left_eye_df_headers 
    
     %% Make all fields numerical (format for now still strings, but enables later conversion to number)
    %Column 3 and 4 should be 0.0 during eyeblinks, not '0.5' otherwise adding these channels to the pupdat structure will fail!
   
    %Left_eye_df 
    for i=1:length(TOS_left_eye_df)
        if strcmp(TOS_left_eye_df(i,3), '0.5') %if there is no value but dot placeholder in file
            % then replace dot with 0.0
            TOS_left_eye_df(i,3) = {'0.0'};
        end
        if strcmp(TOS_left_eye_df(i,4), '0.5') %if there is no value but dot placeholder in file
            % then replace dot with 0.0
            TOS_left_eye_df(i,4) = {'0.0'};
        end
    end
    
    %Right_eye_df
    for i=1:length(TOS_right_eye_df)
        if strcmp(TOS_right_eye_df(i,3), '0.5') %if there is no value but dot placeholder in file
            % then replace dot with 0.0
            TOS_right_eye_df(i,3) = {'0.0'};
        end
        if strcmp(TOS_right_eye_df(i,4), '0.5') %if there is no value but dot placeholder in file
            % then replace dot with 0.0
            TOS_right_eye_df(i,4) = {'0.0'};
        end
    end 
    
    %Check whether there are values below a certain threshold that would
    %indicate a blink.
    %rows_blinks_left_eye = find(left_eye_header_df(:,4) <= '10');
    %rows_blinks_right_eye = find(right_eye_header_df(:,4) <= '10');
   
    %% Put in the trial codes from the annotations file in the trigger column for the TOS_left_eye_df
    % Safe_low = 80;
    % Safe_high = 81;
    % Threat_low = 70;
    % Threat_high = 71;
    
    
    for i = 1:length(TOS_left_eye_df(:,2))

        %Add trial codes for Safe_low cognitive load
        if TOS_left_eye_df(i,2) == TOS_annotations(1,1)
            TOS_left_eye_df(i,6) = {'80'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(2,1)
            TOS_left_eye_df(i,6) = {'80'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(13,1)
            TOS_left_eye_df(i,6) = {'80'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(14,1)
            TOS_left_eye_df(i,6) = {'80'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(23,1) 
            TOS_left_eye_df(i,6) = {'80'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(24,1)
            TOS_left_eye_df(i,6) = {'80'};  
        elseif TOS_left_eye_df(i,2) == TOS_annotations(31,1)
            TOS_left_eye_df(i,6) = {'80'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(32,1)
            TOS_left_eye_df(i,6) = {'80'};
        end
        
        %Add trial codes for Safe_high cognitive load
        if TOS_left_eye_df(i,2) == TOS_annotations(5,1)
            TOS_left_eye_df(i,6) = {'81'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(6,1)
            TOS_left_eye_df(i,6) = {'81'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(15,1)
            TOS_left_eye_df(i,6) = {'81'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(16,1)
            TOS_left_eye_df(i,6) = {'81'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(21,1) 
            TOS_left_eye_df(i,6) = {'81'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(22,1)
            TOS_left_eye_df(i,6) = {'81'};  
        elseif TOS_left_eye_df(i,2) == TOS_annotations(27,1)
            TOS_left_eye_df(i,6) = {'81'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(28,1)
            TOS_left_eye_df(i,6) = {'81'};
        end
        
        %Add trial codes for Threat_low cognitive load
        if TOS_left_eye_df(i,2) == TOS_annotations(7,1)
            TOS_left_eye_df(i,6) = {'70'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(8,1)
            TOS_left_eye_df(i,6) = {'70'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(17,1)
            TOS_left_eye_df(i,6) = {'70'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(18,1)
            TOS_left_eye_df(i,6) = {'70'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(19,1) 
            TOS_left_eye_df(i,6) = {'70'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(20,1)
            TOS_left_eye_df(i,6) = {'70'};  
        elseif TOS_left_eye_df(i,2) == TOS_annotations(29,1)
            TOS_left_eye_df(i,6) = {'70'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(30,1)
            TOS_left_eye_df(i,6) = {'70'};
        end
        
        %Add trial codes for Threat_high cognitive load
        if TOS_left_eye_df(i,2) == TOS_annotations(3,1)
            TOS_left_eye_df(i,6) = {'71'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(4,1)
            TOS_left_eye_df(i,6) = {'71'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(9,1)
            TOS_left_eye_df(i,6) = {'128'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(10,1)
            TOS_left_eye_df(i,6) = {'128'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(11,1) 
            TOS_left_eye_df(i,6) = {'71'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(12,1)
            TOS_left_eye_df(i,6) = {'71'};  
        elseif TOS_left_eye_df(i,2) == TOS_annotations(25,1)
            TOS_left_eye_df(i,6) = {'71'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(26,1)
            TOS_left_eye_df(i,6) = {'71'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(33,1)
            TOS_left_eye_df(i,6) = {'71'};
        elseif TOS_left_eye_df(i,2) == TOS_annotations(34,1)
            TOS_left_eye_df(i,6) = {'71'};
        end
        
    end
    
    %% Put in the trial codes from the annotations file in the trigger column for the TOS_right_eye_df
    % Safe_low = 80;
    % Safe_high = 81;
    % Threat_low = 70;
    % Threat_high = 71;
    
    
    for i = 1:length(TOS_right_eye_df(:,2))

        %Add trial codes for Safe_low cognitive load
        if TOS_right_eye_df(i,2) == TOS_annotations(1,1)
            TOS_right_eye_df(i,6) = {'80'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(2,1)
            TOS_right_eye_df(i,6) = {'80'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(13,1)
            TOS_right_eye_df(i,6) = {'80'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(14,1)
            TOS_right_eye_df(i,6) = {'80'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(23,1) 
            TOS_right_eye_df(i,6) = {'80'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(24,1)
            TOS_right_eye_df(i,6) = {'80'};  
        elseif TOS_right_eye_df(i,2) == TOS_annotations(31,1)
            TOS_right_eye_df(i,6) = {'80'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(32,1)
            TOS_right_eye_df(i,6) = {'80'};
        end
        
        %Add trial codes for Safe_high cognitive load
        if TOS_right_eye_df(i,2) == TOS_annotations(5,1)
            TOS_right_eye_df(i,6) = {'81'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(6,1)
            TOS_right_eye_df(i,6) = {'81'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(15,1)
            TOS_right_eye_df(i,6) = {'81'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(16,1)
            TOS_right_eye_df(i,6) = {'81'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(21,1) 
            TOS_right_eye_df(i,6) = {'81'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(22,1)
            TOS_right_eye_df(i,6) = {'81'};  
        elseif TOS_right_eye_df(i,2) == TOS_annotations(27,1)
            TOS_right_eye_df(i,6) = {'81'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(28,1)
            TOS_right_eye_df(i,6) = {'81'};
        end
        
        %Add trial codes for Threat_low cognitive load
        if TOS_right_eye_df(i,2) == TOS_annotations(7,1)
            TOS_right_eye_df(i,6) = {'70'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(8,1)
            TOS_right_eye_df(i,6) = {'70'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(17,1)
            TOS_right_eye_df(i,6) = {'70'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(18,1)
            TOS_right_eye_df(i,6) = {'70'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(19,1) 
            TOS_right_eye_df(i,6) = {'70'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(20,1)
            TOS_right_eye_df(i,6) = {'70'};  
        elseif TOS_right_eye_df(i,2) == TOS_annotations(29,1)
            TOS_right_eye_df(i,6) = {'70'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(30,1)
            TOS_right_eye_df(i,6) = {'70'};
        end
        
        %Add trial codes for Threat_high cognitive load
        if TOS_right_eye_df(i,2) == TOS_annotations(3,1)
            TOS_right_eye_df(i,6) = {'71'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(4,1)
            TOS_right_eye_df(i,6) = {'71'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(9,1)
            TOS_right_eye_df(i,6) = {'128'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(10,1)
            TOS_right_eye_df(i,6) = {'128'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(11,1) 
            TOS_right_eye_df(i,6) = {'71'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(12,1)
            TOS_right_eye_df(i,6) = {'71'};  
        elseif TOS_right_eye_df(i,2) == TOS_annotations(25,1)
            TOS_right_eye_df(i,6) = {'71'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(26,1)
            TOS_right_eye_df(i,6) = {'71'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(33,1)
            TOS_right_eye_df(i,6) = {'71'};
        elseif TOS_right_eye_df(i,2) == TOS_annotations(34,1)
            TOS_right_eye_df(i,6) = {'71'};
        end
        
    end
    
    %% Find what the rows are between the trigger markers as set above.
    stimOnsets_L = find(diff(TOS_left_eye_df(:,6)>"1")>0)+1; %If you do not want to include the shock trial on/offsets, then replace "1" with "69"
    stimOnsets_R = find(diff(TOS_right_eye_df(:,6)>"1")>0)+1; %If you do not want to include the shock trial on/offsets, then replace "1" with "69"
   
    %Save the stimOnsets_L and stimOnsets_R data frames
    filename=('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/' conf.subject '/stimOnsets_L.mat');
    save(filename,'PTX_Data'); 
    
    %%% Convert this to a string because conversion by '==' will not work otherwise.
    %stimOnsets = arrayfun(@num2str,stimOnsets,'un',0); %This creates a
    %cell array
    %stimOnsets = string(stimOnsets);

    %% Fill in the empty space between the on and off-set markers as indicated by their index number.
    
    % TOS_left_eye_df
    
    % Block 1
TOS_left_eye_df(stimOnsets_L(1,1):stimOnsets_L(2,1),6) = '80';
TOS_left_eye_df(stimOnsets_L(3,1):stimOnsets_L(4,1),6) = '71';
TOS_left_eye_df(stimOnsets_L(5,1):stimOnsets_L(6,1),6) = '81';
TOS_left_eye_df(stimOnsets_L(7,1):stimOnsets_L(8,1),6) = '70';
    %Block 2
TOS_left_eye_df(stimOnsets_L(9,1):stimOnsets_L(10,1),6) = '128';
TOS_left_eye_df(stimOnsets_L(11,1):stimOnsets_L(12,1),6) = '71';
TOS_left_eye_df(stimOnsets_L(13,1):stimOnsets_L(14,1),6) = '80';
TOS_left_eye_df(stimOnsets_L(15,1):stimOnsets_L(16,1),6) = '81';
TOS_left_eye_df(stimOnsets_L(17,1):stimOnsets_L(18,1),6) = '70';
    %Block 3
TOS_left_eye_df(stimOnsets_L(19,1):stimOnsets_L(20,1),6) = '70';
TOS_left_eye_df(stimOnsets_L(21,1):stimOnsets_L(22,1),6) = '81';
TOS_left_eye_df(stimOnsets_L(23,1):stimOnsets_L(24,1),6) = '80';
TOS_left_eye_df(stimOnsets_L(25,1):stimOnsets_L(26,1),6) = '71';
    %Block 4
TOS_left_eye_df(stimOnsets_L(27,1):stimOnsets_L(28,1),6) = '81';
TOS_left_eye_df(stimOnsets_L(29,1):stimOnsets_L(30,1),6) = '70';
TOS_left_eye_df(stimOnsets_L(31,1):stimOnsets_L(32,1),6) = '80';
TOS_left_eye_df(stimOnsets_L(33,1):stimOnsets_L(34,1),6) = '71';

    % TOS_right_eye_df
    
    % Block 1
TOS_right_eye_df(stimOnsets_R(1,1):stimOnsets_R(2,1),6) = '80';
TOS_right_eye_df(stimOnsets_R(3,1):stimOnsets_R(4,1),6) = '71';
TOS_right_eye_df(stimOnsets_R(5,1):stimOnsets_R(6,1),6) = '81';
TOS_right_eye_df(stimOnsets_R(7,1):stimOnsets_R(8,1),6) = '70';
    %Block 2
TOS_right_eye_df(stimOnsets_R(9,1):stimOnsets_R(10,1),6) = '128';
TOS_right_eye_df(stimOnsets_R(11,1):stimOnsets_R(12,1),6) = '71';
TOS_right_eye_df(stimOnsets_R(13,1):stimOnsets_R(14,1),6) = '80';
TOS_right_eye_df(stimOnsets_R(15,1):stimOnsets_R(16,1),6) = '81';
TOS_right_eye_df(stimOnsets_R(17,1):stimOnsets_R(18,1),6) = '70';
    %Block 3
TOS_right_eye_df(stimOnsets_R(19,1):stimOnsets_R(20,1),6) = '70';
TOS_right_eye_df(stimOnsets_R(21,1):stimOnsets_R(22,1),6) = '81';
TOS_right_eye_df(stimOnsets_R(23,1):stimOnsets_R(24,1),6) = '80';
TOS_right_eye_df(stimOnsets_R(25,1):stimOnsets_R(26,1),6) = '71';
    %Block 4
TOS_right_eye_df(stimOnsets_R(27,1):stimOnsets_R(28,1),6) = '81';
TOS_right_eye_df(stimOnsets_R(29,1):stimOnsets_R(30,1),6) = '70';
TOS_right_eye_df(stimOnsets_R(31,1):stimOnsets_R(32,1),6) = '80';
TOS_right_eye_df(stimOnsets_R(33,1):stimOnsets_R(34,1),6) = '71';
    

    
    %% Now that the trigger markers are set based on the index values, remove the index column. 
    TOS_left_eye_df(:,2) = [];
    TOS_right_eye_df(:,2) = [];
    
    %% Save the adjusted string array without all the messages
    %Save the altered string array as .txt
    %Left_eye_df
    fid = fopen(conf.outputfile_left,'wt');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\r\n',TOS_left_eye_df(:,1:5)' );
    fclose(fid);
    
    %Right_eye_df
    fid = fopen(conf.outputfile_right, 'wt');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\r\n',TOS_right_eye_df(:,1:5)' );
    fclose(fid);

% Saved in the following folder on Windows and Mac.
% Z:\CRU\Parkinsons\Jordy\data\001\001_pupil
% \Volumes\BMRI\CRU\Parkinsons\Jordy\data\001\001_pupil
    %% Save the on and offset dataframes from both left and right eye dataframes. 
    %stimOnsets left_eye_df
    save(fullfile(conf.analysisdir,conf.subject,[ conf.subject '_stimOnsets_L']),'stimOnsets_L'); 
    
    %stimOnsets right_eye_df
    save(fullfile(conf.analysisdir,conf.subject,[ conf.subject '_stimOnsets_R']),'stimOnsets_R');
    
% Saved in the following folder on Mac (windows to do)
% \Volumes\BMRI\CRU\Parkinsons\Jordy\analysis\pupil\001
    
end
