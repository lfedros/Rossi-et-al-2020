function shadePlot(x, y, ysd, color, plotOpt, shadeOnly)
%color is either a string(eg: 'r' for red, as in plot) or an
%RGB vector [ R G B]

if nargin <6
    shadeOnly = 0;
end

if nargin <5 || isempty(plotOpt)
    logy = false;
    polar = false;
    inter = false;
else
    switch plotOpt
        case 'logy'
            logy = true;
            polar = false;
            inter = false;
        case 'polar'
            logy = false;
            polar = true;
                        inter = false;

        case 'interval'
             logy = false;
            polar = false;
            inter = true;
    end
end

% make sure inputs are column vectors
if size(x,1) == 1
    x = permute(x, [2,1]);
end
if size(y,1) == 1
    y = permute(y, [2,1]);
end
if size(ysd,1) == 1
    ysd = permute(ysd, [2,1]);
end

if logy
    
    
    fill([x; flipud(x)], [log10(y-ysd); flipud(log10(y+ysd))], color,'linestyle','none','FaceAlpha', 0.2);
    line(x,log10(y),'Color', color, 'LineWidth', 1.5);
    xlim([min(x), max(x)])
    set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015])
    
elseif polar
    
    theta = x;
    data = y;
    [x, y] = pol2cart(theta, data);   % Convert To Cartesian
    [xdw, ydw] = pol2cart(theta, data - ysd);
    [xup, yup] = pol2cart(theta, data + ysd);

    fill([xdw; flipud(xup)], [ydw; flipud(yup)], color,'linestyle','none','FaceAlpha', 0.2);
    line(x,y,'Color', color, 'LineWidth', 1.5);
    xlim([-max(abs([x;y])), max(abs([x;y]))])
    ylim([-max(abs([x;y])), max(abs([x;y]))])
    axis image;
    set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015])
    
    
    
else
    
    if inter
          fill([x; flipud(x)], [ysd(:,1); flipud(ysd(:,2))], color,'linestyle','none','FaceAlpha', 0.2);
    else
      fill([x; flipud(x)], [(y-ysd); flipud((y+ysd))], color,'linestyle','none','FaceAlpha', 0.2);

    end
    if ~shadeOnly
    line(x,y,'Color', color, 'LineWidth', 1.5);
    end
    xlim([min(x), max(x)])
    set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015])
end
return

% %test
% 
% x = 1:100;
% y = 3*x.^2;
% ysd = ones(1,100)*10;
% shadePlot(x,y,ysd, 'b')