%% reproduce Figure02 from Rossi et al. 2020

%% load the data

[postSyn, preSynEX, preSynIN] = load_visual_network('all', repo_path);


%% plot

plot_tuning_dist(preSynEX, preSynIN, postSyn)
