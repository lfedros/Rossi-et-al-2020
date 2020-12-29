function newmap = BlueWhiteRed_burnLFR(n, gamma)

if nargin < 1
    n = 101;
end

if nargin < 2
    gamma = 1;
end

bottom = [0 0 0.5];
botmiddle = [0 0.5 1];
middle = [1 1 1];
topmiddle = [1 0 0];
top = [0.5 0 0];

new = [bottom; botmiddle; middle; topmiddle; top];

oldsteps = linspace(0, 1, 5);
newsteps = linspace(0, 1, n);

for i=1:3
    % Interpolate over RGB spaces of colormap
    newmap(:,i) = min(max(interp1(oldsteps, new(:,i), newsteps)', 0), 1);
end

newmap = newmap.^gamma;
end