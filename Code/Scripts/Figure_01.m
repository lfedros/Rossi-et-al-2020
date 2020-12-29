%% reproduce Figure 1 from Rossi et al. 2020

%% load the data

[postSyn, preSynEX, preSynIN] = load_spatial_network('all', repo_path);

nNet = numel(postSyn); % number of datasets

%% compute input maps in cortical space

opts.saveTo = []; % if specified, figure pdf is saved here
opts.rmax = 500; % lims of XY and R maps in microns
opts.zmax = 700; % depth range of Z map in microns
opts.bin_size = 25; % size of spatial bins in microns
opts.smooth_sigma =1; % std of gaussian smoothing for maps, in bins

for iN =1:nNet
    
    % for each dataset, compute 2D spatial maps and 1D marginals
    % of presynaptic distributions in cortex
    
    [preSynEX(iN).rzMap, preSynEX(iN).xyMap, preSynEX(iN).zDist, preSynEX(iN).rDist] ...
        = rxyz_projection(preSynEX(iN).spaceXYZ, opts); % for excitatory presynaptics
    
    [preSynIN(iN).rzMap, preSynIN(iN).xyMap, preSynIN(iN).zDist, preSynIN(iN).rDist] ...
        = rxyz_projection(preSynIN(iN).spaceXYZ, opts); % for inhibitory presynaptics
    
end

%% plot rz distributions

plot_rz_dist(preSynEX, preSynIN, postSyn, opts)

%% plot xy distributions

plot_xy_dist(preSynEX, preSynIN, postSyn, opts)
