%% reproduce Figure 4 from Rossi et al. 2020

%% load the data

[postSyn, preSynEX, preSynIN]= load_spatial_network('all', repo_path);

nNet = numel(postSyn);

%% set up the stats

post_DS = [postSyn.dirSel];
predicted_DS = [postSyn.predicted_DS];
lm = fitlm(predicted_DS, post_DS);
[ypred,yci] = predict(lm, makeVec(0:0.01:1));
[sortedSel, idxSel] = sort(post_DS, 'ascend');
idxSel(isnan(sortedSel)) = [];

%% plot the figure

figure('Position', [558 401 714 405], 'Color', 'w');

subplot(1,4,1)
plot_spatial_contour(preSynEX, preSynIN, postSyn);
ylabel('Distance (deg)')
xlabel('Distance (deg)')
plot(0,0, '^k', 'MarkerSize', 6,'MarkerFace', 'k')
plot([0 0], [-10 10], '--k')
xlim([-10 10])
ylim([-10 10])
title ('All')
formatAxes

subplot(1,4,2)
weakSel = idxSel(1:3);
plot_spatial_contour(preSynEX(weakSel), preSynIN(weakSel), postSyn(weakSel), [1.5 1.5]);
xlabel('Distance (deg)')
plot(0,0, '^k', 'MarkerSize', 6,'MarkerFace', 'k')
plot([0 0], [-10 10], '--k')
xlim([-10 10])
ylim([-10 10])
title ('Weak DS')
formatAxes

subplot(1,4,3)
strongSel = idxSel(end-2:end);
plot_spatial_contour(preSynEX(strongSel), preSynIN(strongSel), postSyn(strongSel), [1.5 1.5]);
xlabel('Distance (deg)')
plot(0,0, '^k', 'MarkerSize', 6,'MarkerFace', 'k')
plot([0 0], [-10 10], '--k')
xlim([-10 10])
ylim([-10 10])
title ('Strong DS')
formatAxes

subplot(1,4,4)
patch([0:0.01:1, flip(0:0.01:1)], [yci(:,1); flip(yci(:,2))], [0.9 0.9 0.9], 'Edgecolor',[0.9 0.9 0.9] ); hold on
plot([0 1], [0 1]*lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '-r')
plot(predicted_DS(1:13) ,post_DS(1:13),'ok', 'MarkerSize', 8, 'MarkerFace', 'w'); hold on;
plot(predicted_DS(14:17) ,post_DS(14:17),'sk', 'MarkerSize', 8,'MarkerFace', 'w'); hold on;
xlim([-0.1 1.1]); ylim([-0.1 1.1]);
axis square
ylabel('Postsynaptic DS')
xlabel('Presynaptic Exc-Inh DS')
formatAxes
