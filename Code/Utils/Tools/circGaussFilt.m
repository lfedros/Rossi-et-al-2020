function sData = circGaussFilt(data, sigma)
% filter circular data along columns with a gaussian kernel, works by replicating the
% data with copies on both sides. 

[rows, ~] =size(data);

data = repmat(data, 3,1);

smooth = gaussFilt(data, sigma);
% smoothBw = flip(gaussFilt(flip(data,1),sigma),1);
% smooth = smoothFw/2+smoothBw/2;
sData = smooth(rows+1:2*rows, :);

end