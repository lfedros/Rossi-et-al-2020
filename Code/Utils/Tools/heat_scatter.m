function heat_scatter(x,y, cm, heat_map, c_lims, gamma, markers, xbins, ybins)

nP = numel(x);

if isempty(heat_map)
    
    % [xy, xbins, ybins] = cameraLucida.plot_Density2D (x, y, 2, 1, [40 40]);
    [xy, xbins, ybins] = cameraLucida.plot_Density2D (x, y, 5, 1, [120 120]);
    
    xy = xy/max(xy(:));
    
elseif size(heat_map,3) >1
    xy = heat_map(:,:,3)/nanmax(makeVec(heat_map(:,:,3)));
    %     xbins = -(size(heat_map, 2)-1)/2:(size(heat_map, 2)-1)/2;
    %     ybins = -(size(heat_map, 1)-1)/2:(size(heat_map, 1)-1)/2;
else
    xy = heat_map/nanmax(heat_map(:));
    %     xbins = -(size(heat_map, 2)-1)/2:(size(heat_map, 2)-1)/2;
    %     ybins = -(size(heat_map, 1)-1)/2:(size(heat_map, 1)-1)/2;
end

xy = mat2gray(xy, [c_lims]).^gamma;
% xy = mat2gray(xy, [c_lims]);

nC = 500;
% 

switch cm
    case 'red'
cmap = BlueWhiteRed_burnLFR(nC*2+1,gamma);
        cmap = cmap(nC+1:nC*2+1,:);
        
    case 'blu'
cmap = BlueWhiteRed_burnLFR(nC*2+1,gamma);
        cmap = flip(cmap(1:nC+1,:),1);
    case 'mix'
% cmap = BlueWhiteRed(nC+1,gamma);
cmap = BlueWhiteRed_burnLFR(nC*2+1,gamma);

        lims = c_lims(2);
%         rgbPC = ind2rgb(gray2ind(mat2gray(imgaussfilt(heat_map(:,:,1)/nanmax(makeVec(heat_map(:,:,1))),0.1), [-lims, lims]), nC*2+1), cmap);
%         rgbIN = ind2rgb(gray2ind(mat2gray(-imgaussfilt(heat_map(:,:,2)/nanmax(makeVec(heat_map(:,:,2))),0.11), [-lims, lims]), nC*2+1), cmap);
cmap_red = cmap(nC:end, :);
cmap_blue = cmap(1:nC+1, :);
% cmap_red = Reds(nC+1, gamma);
% cmap_blue = gBlues(nC+1, gamma);
% rgbPC = ind2rgb(gray2ind(mat2gray(imgaussfilt(heat_map(:,:,1)/nanmax(makeVec(heat_map(:,:,1))),0.1), [c_lims(1), c_lims(2)]), nC+1), cmap_red);
% %         rgbIN = ind2rgb(gray2ind(mat2gray(-imgaussfilt(heat_map(:,:,2)/nanmax(makeVec(heat_map(:,:,2))),0.1), [-c_lims(2), -c_lims(1)]), nC+1), cmap_blue);
rgbPC = ind2rgb(gray2ind(mat2gray(heat_map(:,:,1), [0.05, c_lims(2)]), nC+1), cmap_red);
        rgbIN = ind2rgb(gray2ind(mat2gray(-heat_map(:,:,2), [-c_lims(2), -0.05]), nC+1), cmap_blue);
%   rgbPC = ind2rgb(gray2ind(mat2gray(heat_map(:,:,1), [0.05, c_lims(2)]), nC), cmap_red);
%         rgbIN = ind2rgb(gray2ind(mat2gray(-heat_map(:,:,2), [-c_lims(2), -0.05]), nC), cmap_blue);   

hsvPC = rgb2hsv(rgbPC);
        hsvIN = rgb2hsv(rgbIN);
        
        H = angle(hsvPC(:,:,2).*exp(1i*hsvPC(:,:,1)*2*pi) + 1.2*hsvIN(:,:,2).*exp(1i*hsvIN(:,:,1)*2*pi))/(2*pi);
        H(H<0) = H(H<0)+1;
        S = abs(hsvPC(:,:,2).*exp(1i*hsvPC(:,:,1)*2*pi) + 1*hsvIN(:,:,2).*exp(1i*hsvIN(:,:,1)*2*pi));
        S = (S/max(S(:))).^gamma;
        % V =  mat2gray((hsvPC(:,:,3)+ hsvIN(:,:,3))/2, [1-lims, 1]);
        V =  mat2gray(1-(heat_map(:,:,3)/nanmax(makeVec(heat_map(:,:,3)))), [-0.4, 0.6]).^gamma;

        cmap = hsv2rgb(cat(3, H,S,V));
end



xy = padarray(xy, [10,10],'replicate');
xbins = [xbins(1)-10:xbins(1)-1, xbins, xbins(end)+1:xbins(end)+10];
ybins = [ybins(1)-10:ybins(1)-1, ybins, ybins(end)+1:ybins(end)+10];
if size(cmap,3)>1
    cmap = padarray(cmap, [10,10,0],'replicate');
end

hold on;
for iP = 1:nP
    
    if size(cmap,3)>1
        
        
        for ic = 1:3
            local_c(ic) = interp2(xbins, ybins, cmap(:,:,ic), x(iP), y(iP), 'linear');
        end
        local_c(local_c<0) = 0;
        
        if ~isnan(local_c)
            if markers(iP) == '^' || markers(iP) == 'o' || markers(iP) == 'v'
                mksz = 3;
            else
                mksz = 4;
            end
            plot(x(iP), y(iP), markers(iP), 'Color', local_c, 'MarkerFaceColor', local_c, 'MarkerSize', mksz);
        else
            iP
        end
    else
        
        local_d = interp2(xbins, ybins, xy, x(iP), y(iP));
        
        if ~isnan(local_d)
            if markers(iP) == '^' || markers(iP) == 'o' || markers(iP) == 'v'
                mksz = 3;
            else
                mksz = 4;
            end
            local_c = interp2(1:3, 0:nC, cmap,1:3,  repmat(local_d*nC,1,3));
            
            plot(x(iP), y(iP), markers(iP), 'Color', local_c, 'MarkerFaceColor', local_c, 'MarkerSize', mksz);
        end
    end
    
    
end