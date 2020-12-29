function plot_angular_stats(preSynEX, preSynIN, postSyn)
% detailed help goes here


%% select only datasets with visually resposive postsynaptic

selectiveNet = ~isnan([postSyn.prefDir]);
preSynEX = preSynEX(selectiveNet);
preSynIN = preSynIN(selectiveNet);
postSyn = postSyn(selectiveNet);

angDist_EX = cat(2, preSynEX.angDist);
andDist_IN = cat(2, preSynIN.angDist);
ang_dir_bins = postSyn(1).ang_dir_bins;

ave_tunePars = mean(cat(2,postSyn.tunePars),2);
ave_tunePars(1) = 180;
tunFitLine= oritune(ave_tunePars, 0:1:360);
tunFitLine = tunFitLine/max(tunFitLine);

post_DS = [postSyn.dirSel];
predicted_DS = [postSyn.predicted_DS];

prefOri = [postSyn.prefOri];
predicted_ori_IN = [preSynIN.predicted_ori];
predicted_ori_EX = [preSynEX.predicted_ori];

%% angular distributions and model
apc = bsxfun(@rdivide, angDist_EX, sum(angDist_EX,1));
ain = bsxfun(@rdivide, andDist_IN, sum(andDist_IN,1));

dd= (apc-ain);
ar = nanmean(apc-ain,2)';
sear = nanstd((apc-ain),1,2)'/sqrt(16);

% predictedDS = (dd(1,:)-dd(7,:))./abs(apc(1,:)+apc(7,:)+ain(1,:)+ain(7,:));
% lm = fitlm(predictedDS, dirSel);
% [ypred,yci] = predict(lm, makeVec(0:0.01:1));
% % plot(predictedDS(1:12) ,dirSel(1:12),'ok', 'MarkerSize', 10); hold on;
% % plot(predictedDS(13:16) ,dirSel(13:16),'sk', 'MarkerSize', 10); hold on;

shiftedAin = circshift(ain, 3,1);
shiftedApc = circshift(apc, 3,1);
shiftedAin = [shiftedAin; shiftedAin(1, :)];
shiftedApc =[shiftedApc; shiftedApc(1, :)];

aveShiftApc = circGaussFilt(mean(shiftedApc,2),0.5);
aveShiftAin = circGaussFilt(mean(shiftedAin,2),0.5);
seShiftApc = std(shiftedApc,1,2)/sqrt(16);
seShiftAin = std(shiftedAin,1,2)/sqrt(16);

fitBins = -pi:pi/6:pi*5/6;
fitPc = flip(aveShiftApc(2:end));
fitIn = flip(aveShiftAin(2:end));

opt = optimoptions(@lsqcurvefit);
opt.Algorithm = 'levenberg-marquardt';
pars0 = [0 0 0 1];
up = [Inf Inf Inf pi/2];
dw = [-Inf -Inf -Inf pi/12];
fitPars = lsqcurvefit(@doubleSinFit, pars0, fitBins, fitPc',dw,up, opt);
fitPC = doubleSinFit(fitPars,linspace(-pi, pi, 1000));

pars0 = [0 0 0 1];
up = [Inf Inf Inf pi/2];
dw = [-Inf -Inf -Inf pi/8];
fitPars = lsqcurvefit(@doubleSinFit, pars0,fitBins, fitIn', dw,up,opt);
fitIN = doubleSinFit(fitPars,linspace(-pi, pi, 1000));




%% Plot
figure('Position', [876 368 621 485], 'Color', 'w');

%% Angular distributions

subplot(3,3,7)
shadePlot(-ang_dir_bins, aveShiftAin, seShiftAin,  'b', [], 1); hold on
plot(linspace(-pi, pi, 1000), fitIN, 'b', 'LineWidth', 1.5); axis square
xlim([-pi-0.2, pi+0.2])
ylim([-0.02 0.2])
set(gca, 'XTick', [-pi 0 pi], 'XtickLabel', [])
ylabel('Presynaptic count')
set(gca, 'XTick', [-pi 0 pi], 'XtickLabel', [-180 0 180]);
xlabel('Delta postsyn direction')
formatAxes

subplot(3,3,4)
shadePlot(-ang_dir_bins, aveShiftApc,seShiftApc, 'r', [], 1); hold on
plot(linspace(-pi, pi, 1000), fitPC, 'r', 'LineWidth', 1.5);axis square
xlim([-pi-0.2, pi+0.2])
ylim([-0.02 0.2])
ylabel('Presynaptic count')
set(gca, 'XTick', [-pi 0 pi], 'XtickLabel', [])
formatAxes

subplot(3,3,1)
plot(0:1:360, circshift(tunFitLine, -90), '--k'); axis square
xlim([180*(-0-0.2)/pi, 180*(2*pi+0.2)/pi])
ylim([0 1]);
set(gca, 'XTick', [ 0 180 360], 'XtickLabel', [])
formatAxes



%% Preferred direction stats

subplot(3,3,3)
plot(dd(7,1:12), dd(1,1:12),  'ok', 'MarkerSize', 8, 'MarkerFace', 'k');hold on
plot(dd(7,13:16), dd(1,13:16),  'sk', 'MarkerSize', 8 , 'MarkerFace', 'k');

% p = signrank(dd(7,:), dd(1,:));
axis square; xlim([-0.2 0.2]); ylim([-0.2 0.2]);
hold on; plot([-1 1], [-1 1] ,'--', 'Color',[ 0.5, 0.5, 0.5], 'LineWidth', 0.2)
% title(sprintf('p= %0.3f', p))
xlabel('Dwnstream Exc-Inh')
ylabel('Upsstream Exc-Inh')
formatAxes

thr = 0;
subplot(3,3,9)
plot(ain(7,1:12), ain(1,1:12), 'ob', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); hold on
plot(ain(7,13:16), ain(1,13:16), 'sb', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); hold on
axis image; xlim([0 0.23]); ylim([0 0.23]);
plot([0, 0.23], [0 0.23], '--', 'Color',[ 0.5, 0.5, 0.5], 'LineWidth', 0.2)
pain = signrank(ain(7, post_DS>thr), ain(1, post_DS>thr));
xlabel('Density DownStream')
ylabel('Density UpStream')
formatAxes

subplot(3,3,6)
plot(apc(7,1:12), apc(1,1:12), '^r', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); hold on
plot(apc(7,13:16), apc(1,13:16), 'vr', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
axis image; xlim([0 0.23]); ylim([0 0.23]);
plot([0, 0.23], [0 0.23], '--', 'Color',[ 0.5, 0.5, 0.5], 'LineWidth', 0.2)
papc = signrank(apc(7,post_DS>thr), apc(1,post_DS>thr));
% xlabel('Density DownStream')
ylabel('Density UpStream')
formatAxes


%% Preferred orientation stats

subplot(3, 3, 8)

for iDb = 1:numel(prefOri)
    if prefOri(iDb) < 15 && predicted_ori_IN(iDb)>165
        predicted_ori_IN(iDb) = predicted_ori_IN(iDb)-180;
    elseif prefOri(iDb) > 165 && predicted_ori_IN(iDb)<15
        predicted_ori_IN(iDb) = predicted_ori_IN(iDb)+180;
        
    end
    
    if iDb <14
        plot(prefOri(iDb), predicted_ori_IN(iDb), 'ob', 'MarkerSize',8, 'MarkerFaceColor', 'b'); hold on
    else
        plot(prefOri(iDb), predicted_ori_IN(iDb), 'sb', 'MarkerSize',8, 'MarkerFaceColor', 'b'); hold on
        
    end
end
axis image; axis square; hold on
plot([0 180], [0 180], '--k')
xlim([-20 200]); ylim([-20 200])
set(gca, 'Xtick', [ 0 180], 'YTick', [0 180]);
ylabel('Elongation angle (deg)')
xlabel('Postsyn pref ori');
formatAxes

subplot(3,3,5)
for iDb = 1:numel(prefOri)
    
    if prefOri(iDb) <= 15 && predicted_ori_EX(iDb)>=165
        predicted_ori_EX(iDb) = predicted_ori_EX(iDb)-180;
    elseif prefOri(iDb) >= 165 && predicted_ori_EX(iDb)<=15
        predicted_ori_EX(iDb) = predicted_ori_EX(iDb)+180;
        
    end
    
    if iDb<14
        plot(prefOri(iDb), predicted_ori_EX(iDb), '^r', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); hold on
    else
        plot(prefOri(iDb), predicted_ori_EX(iDb), 'vr', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); hold on
    end
end

axis image; axis square; hold on
plot([0 180], [0 180], '--k')
xlim([-20 200]); ylim([-20 200])
set(gca, 'Xtick', [ 0 180], 'YTick', [0 180]);
ylabel('Elongation angle (deg)')
formatAxes


end