function plot_ae_dist(preSynEX, preSynIN,postSyn, opts)
% detailed help goes here


aebins = opts.aebins;
all_preSynEX = cat(1, preSynEX.visScaled);
all_preSynIN = cat(1, preSynIN.visScaled);
all_labelsEX = cat(1, preSynEX.labels);
all_labelsIN = cat(1, preSynIN.labels);

all_aeMapEX = imgaussfilt(nanmean(cat(3, preSynEX.aeMap),3),0.75);
all_aeMapEX = all_aeMapEX/max(all_aeMapEX(:));

all_aeMapIN = imgaussfilt(nanmean(cat(3, preSynIN.aeMap),3),0.1);
all_aeMapIN = all_aeMapIN/max(all_aeMapIN(:));


for iN = 1: numel(postSyn)
    if ~isempty(preSynEX(iN).aeMap)
    all_scaled(:,:, iN) = preSynEX(iN).aeMap*numel(preSynEX(iN).labels)...
        + preSynIN(iN).aeMap*numel(preSynIN(iN).labels);
    all_scaled(:,:, iN) = all_scaled(:,:, iN)/max(makeVec(all_scaled(:,:, iN)));
    else
     all_scaled(:,:, iN) = nan(numel(postSyn(iN).ae_bins), numel(postSyn(iN).ae_bins));   
    end
end

% all_aeMapALL = imgaussfilt(nanmean(cat(3, preSynAll.aeMap),3), 0.25);
% all_aeMapALL = all_aeMapALL/max(all_aeMapALL(:));

all_aeMapALL = imgaussfilt(nanmean(all_scaled,3), 0.25);
all_aeMapALL = all_aeMapALL/max(all_aeMapALL(:));


h_map = cat(3, all_aeMapEX, all_aeMapIN, all_aeMapALL);

%% do the plotting

figure('Color', 'w', 'Position', [516 368 354 486]);

subplot(7,1,1)
ave_tunePars = mean(cat(2,postSyn.tunePars),2);
ave_tunePars(1) = 0;
tunFitLine= oritune(ave_tunePars, 0:1:359);
polarplot((0:1:359)*pi/180, tunFitLine, 'k');
set(gca, 'ThetaTick', [0:90:360], 'RTick', []);

subplot(7,1,2:3)
heat_scatter(all_preSynEX(:, 1), all_preSynEX(:, 2), 'red', h_map(:,:,1), [0.0 0.85],1.2, all_labelsEX, aebins, aebins); axis image; hold on
plot(0,0, '^k', 'MarkerFaceColor', 'w')
xlim([-15 15])
ylim([-20 20])
% xlabel('Distance (deg)')
ylabel('Distance (deg)')

formatAxes
subplot(7,1,4:5)
heat_scatter(all_preSynIN(:, 1), all_preSynIN(:, 2), 'blu', h_map(:,:,2), [0.0 0.7],1.2, all_labelsIN, aebins, aebins); axis image; hold on
plot(0,0, '^k', 'MarkerFaceColor', 'w')
formatAxes
xlim([-15 15])
ylim([-20 20])
xlabel('Distance (deg)')
ylabel('Distance (deg)')



formatAxes
subplot(7,1,6:7)
heat_scatter(cat(1, all_preSynIN(:, 1), all_preSynEX(:, 1)), cat(1,all_preSynIN(:, 2), all_preSynEX(:, 2)), ...
'mix', h_map, [0.0 0.7],1.2, cat(1,all_labelsIN, all_labelsEX), aebins, aebins); axis image; hold on
plot(0,0, '^k', 'MarkerFaceColor', 'w')
formatAxes
xlim([-15 15])
ylim([-20 20])
% xlabel('Distance (deg)')
ylabel('Distance (deg)')



end