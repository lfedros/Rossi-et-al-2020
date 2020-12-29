%% reproduce Figure 3 from Rossi et al. 2020

%% load the data

[postSyn, preSynEX, preSynIN]= load_spatial_network('all', repo_path);

nNet = numel(postSyn);

%% compute max normalised input maps in visual space

opts.rmax = 40; % lims of XY and R maps in microns
opts.zmax = 700; % depth range of Z map in microns
opts.smooth_sigma =0.5; % std of gaussian smoothing for maps, in bins
opts.bin_size = 2; % size of spatial bins in microns

labels_EX = [];
labels_IN = [];
for iN =1:nNet
    
    if ~isnan(postSyn(iN).prefDir)
        
        [~, preSynEX(iN).aeMap, ~, ~,~, aebins] = rxyz_projection(preSynEX(iN).visScaled, opts);
        preSynEX(iN).aeMap = preSynEX(iN).aeMap/max(preSynEX(iN).aeMap(:));
        
        [~, preSynIN(iN).aeMap] = rxyz_projection(preSynIN(iN).visScaled, opts);
        preSynIN(iN).aeMap = preSynIN(iN).aeMap/max(preSynIN(iN).aeMap(:));
               
        preSynEX(iN).labels = repmat(postSyn(iN).labels(1), size(preSynEX(iN).visScaled,1),1);
        preSynIN(iN).labels = repmat(postSyn(iN).labels(2), size(preSynIN(iN).visScaled,1),1);
    else
        preSynEX(iN).aeMap = [];
       preSynIN(iN).aeMap = [];
    end
    
end

%% plot ae distributions

opts.aebins = postSyn(1).ae_bins;
plot_ae_dist(preSynEX, preSynIN, postSyn,opts);


%% plot angular stats

plot_angular_stats(preSynEX, preSynIN, postSyn)



