
% Use this script to get Pupil Labs data into the format that is needed for
% the interpol conversion script
subjects = {'001'};

for index=1:length(subjects)

    %% Preparation
    clc;
    clearvars -except subjects index
    restoredefaultpath;
    addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));
    
    %% Configuration with subject specific information
    conf.subject = subjects{index};
    conf.rawdir = '/Volumes/BMRI/CRU/Parkinsons/Jordy/data/';
    % find complete filename using: fullfile(fpath,fname)
    conf.pupillabsdir = fullfile(pf_findfile(conf.rawdir,['/' conf.subject '/' ],'fullfile'),[conf.subject '_pupil']);
    conf.pupillabsfile = pf_findfile(conf.pupillabsdir,'/pupil_positions.csv/','fullfile');
    conf.annotationsfile = pf_findfile(conf.pupillabsdir,'/annotations.csv/','fullfile');
    conf.outputfile = [ conf.pupillabsdir '/' conf.subject '_pupil_positions_recoded.txt' ];
    
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
    
    %% Filter out < % 95 confidence of pupil measurement.
    TOS_high_conf = TOS(TOS(:, 3) >= '0.95', :);
    
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
    
    %% Add annotations in to the trigger column
    % Remove columns from annotations.csv that are unused 
    TOS_annotations(:, 6) = [];
    TOS_annotations(:, 5) = [];
    TOS_annotations(:, 4) = [];
    %Remove header row from annotations.csv
    TOS_annotations(1, :) = [];
   
    %% Put in the trial codes from the annotations file in the trigger column
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
    
    %% Now that the trigger markers are set based on the index values, remove the index column. 
    TOS_left_eye_df(:,2) = [];
    
    %% Save the adjusted string array without all the messages
    %Save the altered string array as .txt
    fid = fopen(conf.outputfile,'wt');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\r\n',TOS_left_eye_df(:,1:5)' );
    fclose(fid);

end
