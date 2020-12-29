function cm = Reds(n, gamma)

if nargin<1; n = 100; end
if nargin<2; gamma = 1; end

cm = ([0:1:n; ...
       zeros(1, n+1);...
      zeros(1, n+1)]' / n).^gamma;

  
colormap(cm);
