%Convert txt files for use with interpol.

%LdV/EJH 2013-5

% Modified and automized for the cambridge study by Jordy van Langen
% March 2020

% The script is fully automized, but only needs 1 manual change:

% 1. Define `subject` as `cn` or `pd`


% In order to use this script, you'll need to be connected to the
% 'fs2.shared.sydney.edu.au' network of The University of Sydney
%--------------------------------------------------------------------------

subject = 'cn'; %change this to 'pd' if analyzing PD patients

%Prompt for the _recoded.txt file
   [fname,fpath]=uigetfile('*.txt',...
       'Get eye tracker .txt file (converted from .idf file)');
   fname=fullfile(fpath,fname); %input file name


    %Also prompt for trial window
    answ1 = inputdlg('Please enter start of trial window relative to trial onset (eg, enter -1 for starting the trial window one second before trial onset). Leave empty if not including trials.','');
    if numel(answ1{1})>0
        answ2 = inputdlg('Please enter end of trial window relative to trial onset (eg, enter 6 for ending the trial window six seconds after trial onset).','');
        trialwindow(1) = str2num(answ1{1});
        trialwindow(2) = str2num(answ2{1});
    else
        trialwindow=[];
    end


    %Also prompt for trial code range
    answ2 = inputdlg('Please enter range of trial codes included in converted file. (e.g., [1:200])','');
    try
        if numel(char(answ2))>0
            trialcoderange=eval(char(answ2));
        else
            trialcoderange=[];
        end
    catch
        error('Cannot get trial code range. Please check this setting.')
    end


if strcmp(subject, 'cn')
    
    % Controls
    outfname=[fname(59:end-4),'.mat']; %output file name
    outfpath=strcat(fpath,outfname); %%Check this path structure because of adding 'pupil' folder
    outfname=fullfile(outfpath); %full outputfile name, incl. path
    disp(['Converting ',fname,' to ',outfname,'.'])

elseif strcmp(subject, 'pd')
    
    % Parkinsons
    outfname=[fname(59:end-4),'.mat']; %output file name
    outfpath=strcat(fpath,outfname); %%Check this path structure because of adding 'pupil' folder
    outfname=fullfile(outfpath); %full outputfile name, incl. path
    disp(['Converting ',fname,' to ',outfname,'.'])
    
end



%Maximum number of columns in the converted datasets.
maxChannels = 12;

%--------------------------------------------------------------------------
%Set up variables for importing data, load data
chList=[];
stringList=[];
for i=1:maxChannels
   chList =  [chList,'imvar{',num2str(i),'},'];
   stringList=[stringList,'%s '];
end
chList =chList(1:end-1);
stringList =stringList(1:end-1);

%Load the data
eval(['[',chList,']=textread(fname,''',stringList,''',''delimiter'',char(9));']);

%Define event channel name (ie column name in the text file to be converted)
EventChannelName = 'Triggers';

%Define channels that are converted into the mat-file (if they exist)
for i = 1:length(imvar{6})
    if imvar{6}(2) == "Right"
        ConvertChannels = {'RIGHT_PUPIL_SIZE'};
    else 
        ConvertChannels = {'LEFT_PUPIL_SIZE'};
    end
end


%Define the sample rate
sR = 500; %500 Hz per second


%Find the line with channel names (assumed to start with "Time")
TimeLine = find(strcmp(imvar{3},'TIMESTAMP'));
if ~(TimeLine>0)
    error('Cannot convert - found no line starting with "TIMESTAMP"');
end

%Now assign variable names (imvar{1} to {n}) to channel names (ConvertChannels)
chMapping=zeros(1,numel(ConvertChannels));
for i=2:maxChannels
    cString = imvar{i}(TimeLine);
    foundNum = find(ismember(ConvertChannels,cString));
    if numel(foundNum)>0
        chMapping(foundNum) = i;
    end
end

%And also find the event channel, set above in EventChannelName
EventChannelnr = [];
for i=2:maxChannels
    if strcmp(imvar{i}(TimeLine),EventChannelName)
        EventChannelnr=i;
    end
end


%--------------------------------------------------------------------------
%Create the data structure for interpol

%Put in sample rate
pupdat.samplerate = sR;

%Loop over channels and copy the data
j=0;
for i=find(chMapping)
    %Get the column number and convert
    cColumn = chMapping(i);
    cChannel = str2num(char(imvar{cColumn}(TimeLine+1:end)));
    %Copy into interpol data structure
    j=j+1;
    pupdat.rawdat{j} = cChannel;
    pupdat.names{j} = ConvertChannels{i};
end

%Get the event channel
EventChannel = str2num(char(imvar{EventChannelnr}(TimeLine+1:end)));

%Get stimulus onsets
stimOnsets=find(EventChannel(2,1));

%Also collect the codes themselves
stimCodes=EventChannel(stimOnsets);

%Split trial codes if out of range (20151116)
if numel(trialcoderange)>0
    stimCodesOOR = stimCodes(~ismember(stimCodes,trialcoderange)); %out of range
    stimOnsetsOOR = stimOnsets(~ismember(stimCodes,trialcoderange)); 
    stimCodesIR = stimCodes(ismember(stimCodes,trialcoderange)); %in range
    stimOnsetsIR = stimOnsets(ismember(stimCodes,trialcoderange));
end

%Put these into each channel
for i=1:numel(pupdat.rawdat)
    pupdat.trialonsets{i}=stimOnsetsIR;
    pupdat.trialcodes{i}=stimCodesIR;
    pupdat.trialonsetsOOR{i}=stimOnsetsOOR;
    pupdat.trialcodesOOR{i}=stimCodesOOR;
    %Also put in the trial window, if entered
    if numel(trialwindow)>0
        pupdat.trialwindow{i}=trialwindow;
    end
end

%Save result
save(outfname,'pupdat');
disp([fname,' has been converted to ',outfname,'.'])
