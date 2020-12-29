function plot_rz_dist(preSynEX, preSynIN, postSyn, opts)
% Distribution density of presynaptics around the postsynaptic neuron
% plotted as a function of radial distance (r) and cortical depth (z). 2D
% density plotted for data pooled across all datasets. 1D marginals in cortical
% depth ploted for individual datasets. 

%INPUTS
% presynEX
% presynIN
% postSyn
% opts

if nargin <3
    postSynZ= [];
else
    postSynZ = cat(1, postSyn.spaceXYZ);
    postSynZ = postSynZ(:,3);
end

if nargin <4
    opts.normalize= 0;
    opts.saveTo = [];
end

all_IN = cat(1, preSynIN.spaceXYZ);
all_EX = cat(1, preSynEX.spaceXYZ);
all_N = [all_IN; all_EX];

[all_rzN, ~,  all_zN,  ~,  zbins, rbins] = rxyz_projection(all_N,  opts);
[all_rzIN, ~, all_zIN] = rxyz_projection(all_IN,  opts);
[all_rzEX, ~, all_zEX] = rxyz_projection(all_EX, opts);

all_zDiff = nanmean(all_zEX*(sum(all_rzN)/sum(all_rzEX))-all_zIN*(sum(all_rzN)/sum(all_rzIN)), 2);

plotNN = all_rzN/nanmax(all_rzN(:));
plotIN = all_rzIN/nanmax(all_rzIN(:));
plotPC = all_rzEX/nanmax(all_rzEX(:));

for iN = 1: numel(postSyn)
[~, ~,  zN(:,iN)] = rxyz_projection([preSynIN(iN).spaceXYZ; preSynEX(iN).spaceXYZ],  opts);
[~, ~, zIN(:,iN)] = rxyz_projection(preSynIN(iN).spaceXYZ,  opts);
[~, ~, zEX(:,iN)] = rxyz_projection(preSynEX(iN).spaceXYZ, opts);

good = ~isnan(zN(:,iN));

samplingCorrection  = nansum(all_zN(good))/nansum(zN(good, iN));
zIN(:,iN) = zIN(:,iN).*samplingCorrection;
zEX(:,iN) = zEX(:,iN).*samplingCorrection;
zN(:,iN) = zN(:,iN).*samplingCorrection;

zDiff(:,iN) = zEX(:,iN)-zIN(:,iN);

end

%% do the plotting

nC = 1001;
cmap = BlueWhiteRed_burnLFR(nC);
% gamma = 1;
lims = 0.7;
result = figure('Position', [362 158 550 750]);

set(result, 'Color', 'w');

subplot(8,3, [3 6])
plot(zbins, zN, 'Color', [0 0 0]); hold on;
plot(zbins,all_zN, 'Color', [0 0 0], 'LineWidth', 2);
ylim([-0.01, 0.2]);
view([90 90])
formatAxes

subplot(8,3, [9 12])
plot(zbins,zIN, 'Color', [0 0 1]); hold on;
plot(zbins,all_zIN, 'Color', [0 0 1], 'LineWidth', 2);
ylim([-0.01, 0.2]);
view([90 90])
formatAxes

subplot(8,3, [15 18])
plot(zbins,zEX,'Color', [1 0 0]); hold on;
plot(zbins,all_zEX, 'Color', [1 0 0], 'LineWidth', 2);
ylim([-0.01, 0.2]);
view([90 90])
formatAxes

subplot(8,3, [21 24])
plot(zbins,zDiff, 'Color', [0 0 0]); hold on;
plot(zbins,all_zDiff, 'Color', [0 0 0], 'LineWidth', 2);
ylim([-0.15, 0.15]);
view([90 90])
ylabel('Density')
formatAxes

nnD = subplot(8,3,[1 2 4 5]);
imagesc(rbins, zbins,plotNN); axis image;hold on
grayInv = flip(gray(100),1); colormap(nnD, grayInv ); caxis([0 0.004])
caxis([0 0.5])
if ~isempty(postSynZ)
    plot(0,postSynZ, '^k', 'MarkerFace', 'w')
end
ylabel('Depth (\mum)')
title('all presyn')
formatAxes

inD = subplot(8,3,[7 8 10 11]);
imagesc(rbins, zbins,-plotIN); axis image;hold on
colormap(inD, cmap); caxis([-lims, lims])
if ~isempty(postSynZ)
    plot(0,postSynZ, '^k', 'MarkerFace', 'w')
end
ylabel('Depth (\mum)')
title('Inh')
formatAxes

pcD = subplot(8,3,[13 14 16 17]);
imagesc(rbins, zbins, plotPC); axis image;hold on
if ~isempty(postSynZ)
    plot(0,postSynZ, '^k', 'MarkerFace', 'w')
end

colormap(pcD, cmap); caxis([-lims, lims])
ylabel('Depth (\mum)')
title('Exc')
formatAxes

subplot(8,3,[19 20 22 23]);

rgbPC = ind2rgb(gray2ind(mat2gray(imgaussfilt(plotPC,1), [-lims, lims]), nC), cmap);
rgbIN = ind2rgb(gray2ind(mat2gray(-imgaussfilt(plotIN,1), [-lims, lims]), nC), cmap);
hsvPC = rgb2hsv(rgbPC);
hsvIN = rgb2hsv(rgbIN);
H = angle(hsvPC(:,:,2).*exp(1i*hsvPC(:,:,1)*2*pi) + hsvIN(:,:,2).*exp(1i*hsvIN(:,:,1)*2*pi))/(2*pi);
H(H<0) = H(H<0)+1;
S = abs(hsvPC(:,:,2).*exp(1i*hsvPC(:,:,1)*2*pi) + hsvIN(:,:,2).*exp(1i*hsvIN(:,:,1)*2*pi));
V =  mat2gray(1-(plotNN), [-(1-lims), lims]);

plotDPcIn = cat(3, H, S, V);

imagesc(rbins, zbins, hsv2rgb(plotDPcIn)); axis image;hold on
if ~isempty(postSynZ)
    plot(0,postSynZ, '^k', 'MarkerFace', 'w')
end
xlabel('Lateral distance (\mum)')
ylabel('Depth (\mum)')
title('Exc - Inh')
formatAxes

if ~isempty(opts.saveTo)
    print(saveTo, '-painters', '-dpdf', '-fillpage');
end

end