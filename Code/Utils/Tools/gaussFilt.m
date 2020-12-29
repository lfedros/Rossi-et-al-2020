function Smooth = gaussFilt(S1, sig)
%smooth matrix along columns

S1 = S1';

NN = size(S1,1);
NT = size(S1,2);

dt = -4*sig:1:4*sig;
gaus = exp( - dt.^2/(2*sig^2));
gaus = gaus'/sum(gaus);

pad = ceil(4*sig);
Smooth = filter(gaus, 1, [S1' ones(NT,1); zeros(pad, NN+1)]);
Smooth = Smooth(1+pad:end, :);
Smooth = Smooth(:,1:NN) ./ (Smooth(:, NN+1) * ones(1,NN));

% Smooth = Smooth';
end