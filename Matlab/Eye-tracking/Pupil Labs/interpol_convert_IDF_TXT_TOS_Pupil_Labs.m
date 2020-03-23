function pupdat = interpol_convert_IDF_TXT_TOS_Pupil_Labs(fname,trialwindow,trialcoderange)

%Convert txt files (first converted from idf using the idf converter on the
%acquisition pc) for use with interpol.
%This function can be called from within interpol or used standalone with
%the following arguments:
%fname: full path/name of the file to be converter
%trialwindow (optional): time window of trials relative to trial onset
%                        e.g. [-1,6] for a window starting one second
%                        before trial onset and ending 6 seconds after
%                        trial onset.
%trialcoderange (optional): range of trial codes to be included in
%                        converted file
%LdV/EJH 2013-5
%--------------------------------------------------------------------------
%Settings

%Define channels that are converted into the mat-file (if they exist)
%ConvertChannels = {'Raw X','Raw Y','Pupil'};
ConvertChannels = {'norm_pos_x','norm_pos_y','diameter'};

%Define event channel name (ie column name in the text file to be converted)
EventChannelName = 'Triggers';

%Maximum number of columns in the converted datasets. It seems 18 is
%sufficient
maxChannels = 8;
%maxChannels = 5; 


%--------------------------------------------------------------------------
%DCCN BITSI information (2015)
% BITSI1 = [1 2 4 8 16 32 64 128];
%    -used for code from Presentation
% BITSI2 = [256 512 1024 2048 4096 8192 16384 32768];
%    -position 1= scantrigger
%    -position 2= Left Index finger
%    -position 3= Left Middle finger
%    -position 4= Right Index finger
%    -position 5= Right Middle finger
%--------------------------------------------------------------------------

%Load data
%if used stand-alone, use GUI to request file
%if no filename is given
if nargin==0
    %Prompt for file
   [fname,fpath]=uigetfile('*.txt',...
       'Get eye tracker .txt file (converted from .idf file)');
   fname=fullfile(fpath,fname); %input file name
end

%if no trial window is given
if nargin<2
    %Also prompt for trial window
    answ1 = inputdlg('Please enter start of trial window relative to trial onset (eg, enter -1 for starting the trial window one second before trial onset). Leave empty if not including trials.','');
    if numel(answ1{1})>0
        answ2 = inputdlg('Please enter end of trial window relative to trial onset (eg, enter 6 for ending the trial window six seconds after trial onset).','');
        trialwindow(1) = str2num(answ1{1});
        trialwindow(2) = str2num(answ2{1});
    else
        trialwindow=[];
    end
end

%if no trial code range is given
if nargin<2
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
end

%Set the output file name ON MAC
%%% outfname=[fname(1:end-3),'mat']; %output file name
%%% replaced by next 3 lines (output data in a different folder)
outfname=[fname(85:end-12),'.mat']; %output file name
outfpath=strcat(fpath,outfname); %%Check this path structure because of adding 'pupil' folder
outfname=fullfile(outfpath); %full outputfile name, incl. path
disp(['Converting ',fname,' to ',outfname,'.'])

%Set the output file name ON WINDOWS
outfname=[fname(44:end-4),'.mat']; %output file name
outfpath=strcat('Z:/CRU/Parkinsons/Jordy/analysis/',outfname(1:3),'/'); %Check this path structure because of adding 'pupil' folder
outfname=fullfile(outfpath,outfname); %full outputfile name, incl. path
disp(['Converting ',fname,' to ',outfname,'.'])
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

% %Column 2 and 3 should be 0.0 during eyeblinks, not '.' otherwise adding these channels to the pupdat structure will fail!
% for i=1:length(imvar{1})
%     
%     if strcmp(imvar{2}(i), '.') %if there is no value but dot placeholder in file
%         % then replace dot with 0.0
%         imvar{2}(i) = {'0.0'};
%     end
%     if strcmp(imvar{3}(i), '.') %if there is no value but dot placeholder in file
%         % then replace dot with 0.0
%         imvar{3}(i) = {'0.0'};
%     end
%     
% end

%--------------------------------------------------------------------------
%Find the sample rate
sR = 120;
% SRline = find(strcmp(imvar{1},'SAMPLES'));
% if SRline>0
%     sR = str2num(imvar{5}{SRline});
% else
%     error('Cannot find sample rate.');
% end

%Find the line with channel names (assumed to start with "Time")
TimeLine = find(strcmp(imvar{1},'timestamp'));
if ~(TimeLine>0)
    error('Cannot convert - found no line starting with "Time"');
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
%%% binEventChannel = dec2bin(EventChannel,16);


%Copy shock triggers into interpol data structure
%%% pupdat.scantriggers = find(diff((bin2dec(binEventChannel(:,8))==1))>0)+1;
pupdat.shocktrigger = find(diff(EventChannel==128)>0)+1;

%Collect all 8 bit event codes sent in through presentation (or other software)
%%% eventCodeChannel=bin2dec(binEventChannel(:,9:16));

%Get stimulus onsets
stimOnsets=find(diff(EventChannel>69)>0)+1;
shockOnset = find(stimOnsets == pupdat.shocktrigger); 
stimOnsets(shockOnset) = []; %Comment this function? Because it removes the shock trial from the stimOnsets

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




