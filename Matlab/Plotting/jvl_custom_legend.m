function [lbl, x,y,z] = jvl_custom_legend(colormap, p)
% Customize your own legend with this simple script
% Jordy van Langen - 11/11/2019

[x,y,z] = peaks;
%z = max(peaks* 100000, 0);
cmap = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0 0 0; 0 1 0];
lbl =  {'THREAT', 'SAFE', 'LOW-LOAD', 'HIGH-LOAD'};
%[n,bin] = histc(z, [0 1 6400 80000 500000 Inf]); 
%pcolor(x,y,bin);
colormap(cmap);

for ii = 1:size(cmap,1)
    p(ii) = patch(NaN, NaN, cmap(ii,:));
end
legend(p, lbl, 'location','northeast','Box','off');


end