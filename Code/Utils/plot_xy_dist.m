function plot_xy_dist(preSynEX, preSynIN, postSyn, opts)
% Distribution density of presynaptics around the postsynaptic neuron
% plotted as a function of ML and AP distance. 2D density plotted for 
% data pooled across all datasets. For 1D marginals, AP and ML distributions
% are converted to radial density distributions, and plotted for 
% individual datasets. 

%INPUTS
% presynEX
% presynIN
% postSyn
% opts


if nargin <3
    postXY= [0,0];
else
    postXY = cat(1, postSyn.spaceXYZ);
    postXY = postXY(:,1:2);
end

if nargin <4
    opts.normalize= 0;
    opts.saveTo = [];
end

% zrange = [0 800];

all_IN = cat(1, preSynIN.spaceXYZ);
all_EX = cat(1, preSynEX.spaceXYZ);
all_N = [all_IN; all_EX];

[~, all_xyN,  ~,  all_rN,  ~, rbins] = rxyz_projection(all_N,  opts);
[~, all_xyIN, ~, all_rIN] = rxyz_projection(all_IN,  opts);
[~, all_xyEX, ~, all_rEX] = rxyz_projection(all_EX, opts);

all_MexHat = all_rEX*(sum(all_rN)/sum(all_rEX))-...
    all_rIN*(sum(all_rN)/sum(all_rIN));
all_rN = mean(all_rN, 2);

sigma = 1;

all_xyIN = imgaussfilt(all_xyIN/sum(all_xyIN(:)), sigma);
all_xyEX = imgaussfilt(all_xyEX/sum(all_xyEX(:)), sigma);
all_xyN = imgaussfilt(all_xyN/sum(all_xyN(:)), sigma);


for iN = 1:numel(postSyn)
[~, ~,  ~,  rN(:, iN)] = rxyz_projection([preSynIN(iN).spaceXYZ; preSynEX(iN).spaceXYZ],  opts);
[~, ~, ~, rIN(:, iN)] = rxyz_projection(preSynIN(iN).spaceXYZ,  opts);
[~, ~, ~, rEX(:, iN)] = rxyz_projection(preSynEX(iN).spaceXYZ, opts); 

MexHat(:, iN) = rEX(:, iN)-rIN(:, iN);
end
%%
nC = 1001;
cmap = BlueWhiteRed_burnLFR(nC); 

% gamma = 1;
lims = 0.8;
result = figure;
set(result, 'Position',[950 417 633 486] , 'Color', 'w');
set(result,'PaperOrientation','landscape');

    
subplot(3,8, [1 2])
plot(rbins,rN, 'Color', [0 0 0]); hold on;
plot(rbins,all_rN, 'Color', [0 0 0], 'LineWidth', 2)
ylim([-0.015, 0.15]); 
title('All presyn')
formatAxes

subplot(3,8, [3 4])
plot(rbins,rIN, 'Color', [0 0 1]); hold on;
plot(rbins,all_rIN, 'Color', [0 0 1], 'LineWidth', 2)
ylim([-0.015, 0.15]); 
title('Inh')
formatAxes

subplot(3,8,  [5 6])
plot(rbins,rEX, 'Color', [1 0 0]); hold on;
plot(rbins,all_rEX, 'Color', [1 0 0], 'LineWidth', 2)
ylim([-0.015, 0.15]);
title('Exc')
formatAxes

subplot(3,8, [7 8])
plot(rbins,MexHat, 'Color', [0 0 0]); hold on;
plot(rbins,all_MexHat, 'Color', [0 0 0], 'LineWidth', 2)
ylim([-0.04, 0.04]); 
title('Exc - Inh')
formatAxes

nnD = subplot(3,8,[9 10 17 18]);
plotN = all_xyN/nanmax(all_xyN(:));

imagesc(rbins, rbins,plotN); axis image;hold on; axis xy;
grayInv = flip(gray(100),1); colormap(nnD, grayInv); caxis([0 0.004])
caxis([0 lims])
plot(postXY(1),postXY(2), '^k', 'MarkerFace', 'w')
formatAxes
xlabel('Distance (\mum)')
ylabel('Distance (\mum)')


inD = subplot(3,8,[11 12 19 20]);
plotIN = all_xyIN/nanmax(all_xyIN(:));
imagesc(rbins, rbins,-plotIN); axis image;hold on; axis xy;
colormap(inD, cmap); caxis([-lims, lims])

plot(postXY(1),postXY(2), '^k', 'MarkerFace', 'w')
formatAxes
xlabel('Distance (\mum)')

pcD = subplot(3,8,[13 14 21 22]);
plotPC = all_xyEX/nanmax(all_xyEX(:));
imagesc(rbins, rbins, plotPC); axis image;hold on; axis xy;
plot(postXY(1),postXY(2), '^k', 'MarkerFace', 'w')
colormap(pcD, cmap); caxis([-lims, lims])

formatAxes
xlabel('Distance (\mum)')

subplot(3,8,[15 16 23 24]);

%%
lims = 0.7;
rgbPC = ind2rgb(gray2ind(mat2gray(imgaussfilt(plotPC,1), [-lims, lims]), nC), cmap);   
rgbIN = ind2rgb(gray2ind(mat2gray(-imgaussfilt(plotIN,1), [-lims, lims]), nC), cmap);   
hsvPC = rgb2hsv(rgbPC);
hsvIN = rgb2hsv(rgbIN);
H = angle(hsvPC(:,:,2).*exp(1i*hsvPC(:,:,1)*2*pi) + hsvIN(:,:,2).*exp(1i*hsvIN(:,:,1)*2*pi))/(2*pi);
H(H<0) = H(H<0)+1;
S = abs(hsvPC(:,:,2).*exp(1i*hsvPC(:,:,1)*2*pi) + hsvIN(:,:,2).*exp(1i*hsvIN(:,:,1)*2*pi));
V =  mat2gray((hsvPC(:,:,3)+ hsvIN(:,:,3))/2, [1-lims, 1]);

plotDPcIn = cat(3, H, S, V);
image(rbins, rbins,hsv2rgb(plotDPcIn)); axis image;hold on; axis xy;
plot(postXY(1),postXY(2), '^k', 'MarkerFace', 'w')
formatAxes
xlabel('Distance (\mum)')

%%
if ~isempty(opts.saveTo)
    print(saveTo, '-painters', '-dpdf', '-fillpage');
end
end