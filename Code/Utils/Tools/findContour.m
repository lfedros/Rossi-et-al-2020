function [cc_val, cc_map, cc_centre] = findContour(data, cc, bins)

if nargin < 3
    
  bins = []; 
else
    
    centre = round(numel(bins)/2);
    binsize = unique(diff(bins));
    
end

data = data/max(makeVec(data));

howmuchIN = sort(data(:), 'descend'); howmuchIN = howmuchIN(howmuchIN>0);
howmuchINcum = cumsum(howmuchIN(howmuchIN>0));
howmuchINcum = howmuchINcum/max(howmuchINcum );

for ic = 1:numel(cc)
    cc_val(ic) = find(howmuchINcum >= cc(ic), 1, 'first');
    cc_val(ic) = howmuchIN(cc_val(ic));
    
    if ~isempty(bins)
        
    cc_map{ic} = contourc(bins, bins, data, [cc_val(ic) cc_val(ic)]);
    else
        cc_map{ic} = contourc(data, [cc_val(ic) cc_val(ic)]);

    end
        cc_map{ic} = cc_map{ic}(:,2:end);

    cc_centre(ic,:) = mean(cc_map{ic}, 2);
end




end