%% GENERAL

addpath(genpath('/Volumes/BMRI/CRU/Parkinsons/Jordy/analysis/SupportingScripts'));

% set the tickdirs to go out - need this specific order
set(groot, 'DefaultAxesTickDir', 'out');
set(groot, 'DefaultAxesTickDirMode', 'manual');

% general graphics, this will apply to any figure you open (groot is the default figure object).
% I have this in my startup.m file, so I don't have to retype these things whenever plotting a new fig.
set(groot, ...
    'DefaultFigureColorMap', linspecer, ...
    'DefaultFigureColor', 'w', ...
    'DefaultAxesLineWidth', 0.5, ...
    'DefaultAxesXColor', 'k', ...
    'DefaultAxesYColor', 'k', ...
    'DefaultAxesFontUnits', 'points', ...
    'DefaultAxesFontSize', 8, ...
    'DefaultAxesFontName', 'Helvetica', ...
    'DefaultLineLineWidth', 1, ...
    'DefaultTextFontUnits', 'Points', ...
    'DefaultTextFontSize', 8, ...
    'DefaultTextFontName', 'Helvetica', ...
    'DefaultAxesBox', 'off', ...
    'DefaultAxesTickLength', [0.02 0.025]);

% type cbrewer without input args to see all possible sets of colormaps
colors = cbrewer('qual', 'Set1', 8);

% These text and line sizes are best suited to subplot(4,4,x),
% which makes them about the right size for printing in a paper when saved to an A4 pdf.

%% TIME COURSES WITH SHADED ERRORBARS

time = 1:1:12000; % seconds, sampled at 120 Hz 
data(:, :, 1) = [threat_low_time_course];
data(:, :, 2) = [threat_high_time_course];
%data(:, :, 1) = bsxfun(@plus, sin(time), randn(100, length(time)));
%data(:, :, 2) = bsxfun(@plus, cos(time), randn(100, length(time)));

colors = cbrewer('qual', 'Paired', 8);
% A nice default colormap is: 
% colors = [0.1216, 0.4667, 0.7059];

%% Plot the figure
fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
%subplot(4,4,[13 14]);  % plot across two subplots
hold on;
[l,p] = boundedline(time, mean(data(:, :, 1)), se_1,  ...
    'cmap', colors, ...
    'alpha');
outlinebounds(l,p);

%% Calculate the error bars
n = 24;
se_1 = std(data(:,:,1)) / sqrt(n);
se_2 = std(data(:,:,2)) / sqrt(n);

% boundedline has an 'alpha' option, which makes the errorbars transparent
% (so it's nice when they overlap). However, when saving to pdf this makes
% the files HUGE, so better to keep your hands off alpha and make the final
% figure transparant in illustrator

xlim([-0.4 max(time)]); xlabel('Time (s)'); ylabel('Signal');
xlim([0 2700]);
ylim([41 46]);

% instead of a legend, show colored text
lh = legend(bl);
legnames = {'sin', 'cos'};
for i = 1:length(legnames),
    str{i} = ['\' sprintf('color[rgb]{%f,%f,%f} %s', colors(i, 1), colors(i, 2), colors(i, 3), legnames{i})];
end
lh.String = str;
lh.Box = 'off';

% move a bit closer
lpos = lh.Position;
lpos(1) = lpos(1) + 0.15;
lh.Position = lpos;

% you'll still have the lines indicating the data. So far I haven't been
% able to find a good way to remove those, so you can either remove those
% in Illustrator, or use the text command to plot the legend (but then
% you'll have to specify the right x and y position for the text to go,
% which can take a bit of fiddling).

% we might want to add significance indicators, to show when the time
% courses are different from each other. In this case, use an uncorrected
% t-test
for t = 1:length(time),
    [~, pval(t)] = ttest(data(:, t, 1), data(:, t, 2));
end
% convert to logical
signific = nan(1, length(time)); signific(pval < 0.001) = 1;
plot(time, signific * -3, '.k');
% indicate what we're showing
text(10.2, -3, 'p < 0.001');



% to - do
% adjust colors to blue and grey background

%Lay-out settings for a high quality figure.
        fig = figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]);
        set(gca,'FontName','Helvetica','FontSize',14);
        set(gca,'Box','off','TickLength',[.01 .01], ...
        'XMinorTick','off','YMinorTick','off', ...
        'XColor',[0 0 0],'YColor',[0 0 0],'LineWidth',2);
        hxLabel = xlabel('\fontsize{16} Time (s)','Color', [0 0 0]); 
        hYLabel = ylabel('\fontsize{16}  Signal','Color', [0 0 0]);


%%%%%%%%%%%%%%%% TEST %%%%%%%%%%%%%%%%%%%%%%   

axes = findobj(gcf, 'type', 'axes');
for a = 1:length(axes),
    if axes(a).YColor < [1 1 1],
        axes(a).YColor = [0 0 0];
    end
    if axes(a).XColor < [1 1 1],
        axes(a).XColor = [0 0 0];
    end
end




colors = [31, 119, 180];
for i = (colors)
    [r, g, b] = colors(i); 
    colors = (31 / 255)  (119 / 255) (180 / 255);
  
end