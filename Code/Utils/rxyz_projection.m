function [rz, xy, z, r, zbins, rbins] = rxyz_projection(data, opts)
% detailed help goes here


if size(data,2)<3 
    data(:,3) = zeros(size(data,1),1);
end

sigma = opts.smooth_sigma; % bins
rbins = -opts.rmax:opts.bin_size:opts.rmax; % microns
zbins = 0:opts.bin_size:opts.zmax; % microns
rots = 0:10:350; % deg

for iAngle = 1: numel(rots)
    % Create rotation matrix
    theta = rots(iAngle); 
    R = [cosd(theta) -sind(theta) 0; sind(theta) cosd(theta) 0; 0 0 1];
    
    % rotate coordinates
    cr = R*data';
    
    % calculate rz density and marginals
    [rza, ~] = hist3(double([cr(1,:);cr(3,:)])', {rbins, zbins});  
    rza = imgaussfilt(rza, sigma);
    rz(:,:, iAngle) = rza/sum(rza(:));
    z(:, iAngle) = sum(rz(:, :, iAngle), 1);
    r(:, iAngle) = sum(rz(:, :, iAngle), 2);
   
end


rz = mean(rz,3)';

lastZ = find(mean(z, 2) >0, 1, 'last');

z(lastZ+1:end, :) =NaN;

z = nanmean(z, 2);

r = nanmean(r, 2);

zbins = zbins+opts.bin_size/2;

% calculate xy density and marginals
[xy, ~] = hist3(double([data(:,2),data(:,1)]), {rbins, rbins});  
xy = imgaussfilt(xy, sigma);
xy = xy/sum(xy(:));

end