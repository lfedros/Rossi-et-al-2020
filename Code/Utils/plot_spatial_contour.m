function plot_spatial_contour(preSynEX, preSynIN, postSyn, sigma, cc)
% detailed help goes here

if nargin < 5 
    cc = 0.1;
end

if nargin < 4
    sigma = [0.1, 0.75];
end

all_preSynEX = cat(3, preSynEX.templateMap);
all_preSynIN = cat(3, preSynIN.templateMap);

aveAlignedIN = nanmean(imgaussfilt(all_preSynIN,sigma(1)), 3);
centeredIN = -aveAlignedIN/nanmax(aveAlignedIN(:));

aveAlignedPC = nanmean(imgaussfilt(all_preSynEX,sigma(2)), 3);
centeredPC = aveAlignedPC/nanmax(aveAlignedPC(:));

[nE, nA] = size(centeredPC);
[gridA, gridE] = meshgrid(1:nE, 1:nA);
center = ceil(nE/2);

xbins = postSyn(1).ae_bins;
ybins = postSyn(1).ae_bins;

%%
lims = 0.9;
gamma = 1;

[ccIN, ccmapIN, cccentreIN] = findContour(-centeredIN, cc, xbins);
[ccPC, ccmapPC,  cccentrePC] = findContour(centeredPC, cc, xbins);

yC = (cccentreIN(2)+ cccentrePC(2))/2;

patch(ccmapIN{1}(1,:),ccmapIN{1}(2,:)-cccentreIN(2),  'b', 'FaceAlpha', .2, 'Edgecolor', 'b'); axis image;hold on; axis xy; hold on
patch(ccmapPC{1}(1,:), ccmapPC{1}(2,:)-cccentrePC(2),  'r', 'FaceAlpha', .2, 'Edgecolor', 'r'); 





end



