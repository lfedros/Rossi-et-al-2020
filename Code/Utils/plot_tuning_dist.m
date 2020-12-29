function plot_tuning_dist(visualEX, visualIN, postSyn)
% detailed help goes here

%% gather the data

all_EX = circGaussFilt(cat(2, visualEX.dir_all),0.5);
L23_EX = circGaussFilt(cat(2, visualEX.dir_L23),0.5);
L4_EX = circGaussFilt(cat(2, visualEX.dir_L4),0.5);
all_IN = circGaussFilt(cat(2, visualIN.dir_all),0.5);

goodNet = 1:numel(postSyn);
exclude = cell2mat(cellfun(@isempty, {visualEX.dir_all}, 'UniformOutput', false));
goodNet(exclude) = [];

postSyn_resp = cat(2, postSyn(goodNet).aligned_tuning);

postSyn_resp = bsxfun(@rdivide, postSyn_resp, sum(postSyn_resp(1:12,:),1));
%% median and mad and pKW

ave_postSyn = mean(postSyn_resp,2);
se_postSyn = std(postSyn_resp, [], 2)/sqrt(size(postSyn_resp,2));
se_postSyn = se_postSyn/max(ave_postSyn);
ave_postSyn = ave_postSyn/max(ave_postSyn);


% pKW.all_EX = kruskalwallis(all_EX', [],'off');
% pKW.L23_EX = kruskalwallis(L23_EX', [],'off');
% pKW.L4_EX = kruskalwallis(L4_EX', [],'off');
% pKW.all_IN = kruskalwallis(all_IN', [],'off');

ave_all_EX = nanmedian(all_EX,2);
se_all_EX = mad(all_EX,1,2);

ave_L23_EX = nanmedian(L23_EX,2);
se_L23_EX = mad(L23_EX,1,2);

ave_L4_EX = nanmedian(L4_EX,2);
se_L4_EX = mad(L4_EX,1,2);

ave_all_IN = nanmedian(all_IN,2);
se_all_IN = mad(all_IN,1,2);

%% fit curves

dirs = 0:30:330;

pars.postSyn = fitori(dirs', ave_postSyn(1:12));
tuning.postSyn = oritune(pars.postSyn, linspace(0, 360, 1000));

pars.all_EX = fitori(dirs', ave_all_EX);
tuning.all_EX = oritune(pars.all_EX, linspace(0, 360, 1000));

pars.L23_EX = fitori(dirs', ave_L23_EX);
tuning.L23_EX = oritune(pars.L23_EX, linspace(0, 360, 1000));

pars.L4_EX = fitori(dirs', ave_L4_EX);
tuning.L4_EX = oritune(pars.L4_EX, linspace(0, 360, 1000));

pars.all_IN = fitori(dirs', ave_all_IN);
tuning.all_IN = oritune(pars.all_IN, linspace(0, 360, 1000));

%% replicate 0:360
ave_all_EX = [ave_all_EX; ave_all_EX(1)];
se_all_EX = [se_all_EX; se_all_EX(1)];

ave_L23_EX = [ave_L23_EX; ave_L23_EX(1)];
se_L23_EX = [se_L23_EX; se_L23_EX(1)];

ave_L4_EX = [ave_L4_EX; ave_L4_EX(1)];
se_L4_EX = [se_L4_EX; se_L4_EX(1)];

ave_all_IN = [ave_all_IN; ave_all_IN(1)];
se_all_IN = [se_all_IN; se_all_IN(1)];

all_EX = [all_EX; all_EX(1,:)];
L23_EX = [L23_EX; L23_EX(1,:)];
L4_EX = [L4_EX; L4_EX(1,:)];
all_IN = [all_IN; all_IN(1,:)];

%%
figure('Position', [546 197 652 702], 'Color', 'w');

goodNet = 1:numel(postSyn);
exclude = cell2mat(cellfun(@isempty, {visualEX.dir_all}, 'UniformOutput', false));
goodNet(exclude) = [];

chosen = [13:14];
nD = numel(chosen);

for iD = 1:nD

thisNet = goodNet(chosen(iD));    

subplot(5,nD+1,iD)
color = [0 0 0];
deltaDir = mod(postSyn(thisNet).prefDir, 30); 
if deltaDir <15
    thisNetTuning = oritune([(180-deltaDir) ; postSyn(thisNet).tunePars(2:end)], linspace(0, 360, 1000));
    resp = oritune([(180-deltaDir) ; postSyn(thisNet).tunePars(2:end)], 0:30:360);
else
    thisNetTuning = oritune([(180-(30-deltaDir)) ; postSyn(thisNet).tunePars(2:end)], linspace(0, 360, 1000));
    resp = oritune([(180-(30-deltaDir)) ; postSyn(thisNet).tunePars(2:end)], 0:30:360);
end
resp = resp/max(thisNetTuning);
thisNetTuning = thisNetTuning/max(thisNetTuning);

plot(-180:30:180,resp, 'o','Color', color, 'MarkerFace', color); hold on;
plot(linspace(-180, 180, 1000), thisNetTuning, 'Color', color, 'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 1.25])
ylabel('Response')
formatAxes
title(sprintf('Neuron %02d', thisNet))

subplot(5,nD+1,(nD+1)*1 +iD)
color = [1 0 0];
plot(-180:30:180, all_EX(:,chosen(iD))' , 'o','Color', color, 'MarkerFace', color); hold on;
thisNetTuning = oritune(visualEX(thisNet).dirPars.all, linspace(0, 360, 1000));
plot(linspace(-180, 180, 1000), thisNetTuning, 'Color', color, 'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 0.25])
formatAxes

subplot(5,nD+1,(nD+1)*2+iD)
color = [0.7 0 0];
plot(-180:30:180, L23_EX(:,chosen(iD))',  'o','Color', color, 'MarkerFace', color); hold on;
thisNetTuning = oritune(visualEX(thisNet).dirPars.L23, linspace(0, 360, 1000));
plot(linspace(-180, 180, 1000), thisNetTuning, 'Color', color,  'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 0.25])
ylabel('Presynaptic fraction')
formatAxes

subplot(5,nD+1,(nD+1)*3+iD)
color = [0.4 0 0];
plot(-180:30:180, L4_EX(:,chosen(iD))', 'o', 'Color', color, 'MarkerFace', color); hold on;
thisNetTuning = oritune(visualEX(thisNet).dirPars.L4, linspace(0, 360, 1000));
plot(linspace(-180, 180, 1000), thisNetTuning, 'Color', color,  'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 0.25])
formatAxes

subplot(5,nD+1,(nD+1)*4+iD)
color = [0 0.5 1];
plot(-180:30:180, all_IN(:,chosen(iD))', 'o', 'Color', color, 'MarkerFace', color); hold on;
thisNetTuning = oritune(visualIN(thisNet).dirPars.all, linspace(0, 360, 1000));
plot(linspace(-180, 180, 1000), thisNetTuning, 'Color', color,  'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 0.25])
xlabel('\Delta preferred direction (deg)')
formatAxes
    
    
    
end


%

subplot(5,nD+1,nD+1)
color = [0 0 0];
errorbar(-180:30:180, ave_postSyn', se_postSyn',  'o','Color', color, 'MarkerFace', color); hold on;
plot(linspace(-180, 180, 1000), tuning.postSyn, 'Color', color, 'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 1.2])
ylabel('Response')
formatAxes
title ('All postsynaptic neurons')

subplot(5,nD+1,(nD+1)*2)
color = [1 0 0];
errorbar(-180:30:180, ave_all_EX', se_all_EX',  'o','Color', color, 'MarkerFace', color); hold on;
plot(linspace(-180, 180, 1000), tuning.all_EX, 'Color', color, 'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 0.2])
formatAxes

subplot(5,nD+1,(nD+1)*3)
color = [0.7 0 0];
errorbar(-180:30:180, ave_L23_EX', se_L23_EX',  'o','Color', color, 'MarkerFace', color); hold on;
plot(linspace(-180, 180, 1000), tuning.L23_EX, 'Color', color,  'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 0.2])
ylabel('Presynaptic fraction')
formatAxes

subplot(5,nD+1,(nD+1)*4)
color = [0.4 0 0];
errorbar(-180:30:180, ave_L4_EX', se_L4_EX', 'o', 'Color', color, 'MarkerFace', color); hold on;
plot(linspace(-180, 180, 1000), tuning.L4_EX, 'Color', color,  'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 0.2])
formatAxes

subplot(5,nD+1,(nD+1)*5)
color = [0 0.5 1];
errorbar(-180:30:180, ave_all_IN', se_all_IN', 'o', 'Color', color, 'MarkerFace', color); hold on;
plot(linspace(-180, 180, 1000), tuning.all_IN, 'Color', color,  'Linewidth', 1); hold on
set(gca,'XTick', [-180 0 180])
xlim([-195 195]); ylim([0 0.2])
xlabel('\Delta preferred direction (deg)')
formatAxes

end