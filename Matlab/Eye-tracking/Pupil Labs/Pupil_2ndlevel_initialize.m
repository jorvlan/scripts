%% This script initializes empty .mat files before group analysis
% Only use this script once i.e., before you start doing 2nd level analysis

% Jordy van Langen
% December 2019
% e-mail: jordy.vanlangen@sydney.edu.au

%% Define where saved data and figures are stored 
conf.output.dir = [ '/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/pupil/2ndlevel' ];
conf.output.save = 'yes';
if ~exist(conf.output.dir)
    mkdir(conf.output.dir);
end

%% Initialize empty dataframes

group_threat_low_time_course = [];
group_threat_high_time_course = [];
group_safe_low_time_course = [];
group_safe_high_time_course = [];
group_shock_time_course = [];
group_statistics = [];

%% Save the empty dataframes as .mat files

if strcmp(conf.output.save,'yes')
    group_threat_low_time_course = group_threat_low_time_course;
    save(fullfile(conf.output.dir,[ 'group_threat_low_time_course']),'group_threat_low_time_course'); 
end

if strcmp(conf.output.save,'yes')
    group_threat_high_time_course = group_threat_high_time_course; 
    save(fullfile(conf.output.dir,[ 'group_threat_high_time_course']),'group_threat_high_time_course'); 
end

if strcmp(conf.output.save,'yes')
    group_safe_low_time_course = group_safe_low_time_course; 
    save(fullfile(conf.output.dir,[ 'group_safe_low_time_course']),'group_safe_low_time_course'); 
end

if strcmp(conf.output.save,'yes')
    group_safe_high_time_course = group_safe_high_time_course; 
    save(fullfile(conf.output.dir,[ 'group_safe_high_time_course']),'group_safe_high_time_course'); 
end

if strcmp(conf.output.save,'yes')
    group_shock_time_course = group_shock_time_course;
    save(fullfile(conf.output.dir,[ 'group_shock_time_course']),'group_shock_time_course'); 
end

if strcmp(conf.output.save,'yes')
    group_statistics= group_statistics;
    save(fullfile(conf.output.dir,[ 'group_statistics']),'group_statistics'); 
end
