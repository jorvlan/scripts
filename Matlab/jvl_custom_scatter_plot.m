%% custom script containing settings for a high-quality figure.

%First load example data
load('/Users/pdclinic/MATLAB/Matlab_course_Donders_Institute/Files/jvl_custom_scatter_plot')

%Create a customized figure
figure('units','centimeters','outerposition',[0 0 25 20],'Color',[1 1 1]); hold on

%Plot the data from the NL group (containing 3 levels)
plot(weightNL, BMI18_5_NL,'o','MarkerEdgeColor',[0.73 0.49 0.0],...
              'MarkerFaceColor',[0.93 0.69 0.0],...
              'LineWidth',1, 'MarkerSize',7)
plot(weightNL, BMI25_NL,'o', 'MarkerEdgeColor',[.5 .5 .5],...
              'MarkerFaceColor',[.7 .7 .7],...
              'LineWidth',1, 'MarkerSize',7)
plot(weightNL, BMI30_NL,'o', 'MarkerEdgeColor',[0.10 0.54 0.73],...
              'MarkerFaceColor',[0.30 0.74 0.93],...
              'LineWidth',1, 'MarkerSize',7)

%Lay-out settings for a high quality figure.
        xlabel('\fontsize{16} X-LABEL', 'Color', [0 0 0]) 
        hYLabel = ylabel('\fontsize{16}  Y-LABEL','Color', [0 0 0]);
        set(gca,'FontWeight', 'bold','FontName','Helvetica','FontSize',14);
        set(gca,'Box','off','TickLength',[.01 .01], ...
        'XMinorTick','off','YMinorTick','off', ...
        'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',2);
    
%Legend settings for high quality figure. (Gives legend objects in squares).    
        [x,y,z] = peaks;
         %z = max(peaks* 100000, 0);
        cmap = [0.93 0.69 0.0;.7 .7 .7;0.30 0.74 0.93];
        lbl =  {'BMI - 18.5', 'BMI - 25', 'BMI - 30'};
        %[n,bin] = histc(z, [0 1 6400 80000 500000 Inf]); 
        %pcolor(x,y,bin);
        colormap(cmap);

        for ii = 1:size(cmap,1)
             p(ii) = patch(NaN, NaN, cmap(ii,:));
        end
        legend(p, lbl, 'location','northeast','Box','off','FontSize',14);


% Simple legend code to keep the legend objects the same as the
% scatterpoints.
legendNames =  {'BMI - 18.5', 'BMI - 25', 'BMI - 30'}; %First put your legend names in a cell.
legend(legendNames, 'location','northeast','Box','off');

% Optional:
% Add a horizontal or vertical line to indicate e.g., average values
%length_line_NL = yline(average_length_NL,'o', 'Average length Dutch');
%weight_line_NL = xline(average_weight_NL, 'o', 'Average weight Dutch');

%Save the example dataset
save('/Users/pdclinic/MATLAB/Matlab_course_Donders_Institute/Files/jvl_custom_scatter_plot')