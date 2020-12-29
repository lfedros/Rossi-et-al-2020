function [postSyn, preSynEX, preSynIN]= load_visual_network(ID, path)
% loads the source data with distributions of visual tuning of neurons 

% INPUTS
% ID: scalar id for each dataset, range 1:17. Alternatively, to load all
% datasets, string 'all' (default)
% path: directory of the Github repository
%
% OUTPUTS
% postSyn: struct containing data about the postsynaptic neuron
% preSynEX: struct containing data about excitatory presynaptic neurons
% preSynIN: struct containing data about inhibitory presynaptic neurons


if nargin == 2
    cd(fullfile(path, 'Data'));
else
    cd('C:\Users\Federico\Documents\GitHub\Rossi-et-al-2020\Data');
end

post_list = dir('*postSyn*.mat');


net_ID = str2double(regexp({post_list.name}, '\d{2}', 'match', 'once'));

if ID =='all'
    
    to_load = 1:numel(net_ID);
else
    [~, to_load] = intersect(net_ID, ID);
end


for iN = 1:numel(to_load)
    postSyn(iN) = load(post_list(to_load(iN)).name);
    preSynEX(iN) = struct('dir_all', [], 'dir_L23', [],'dir_L4', [],'oriPars', [], 'dirPars', []);
    preSynIN(iN) = struct('dir_all', [], 'dir_L23', [],'dir_L4', [],'oriPars', [], 'dirPars', []);
    
    net_name = sprintf('visualEX_%02d.mat', net_ID(to_load(iN)));
    if ~isnan(postSyn(iN).prefDir) && exist(net_name, 'file')
        preSynEX(iN) = load(sprintf('visualEX_%02d', net_ID(to_load(iN))));
        preSynIN(iN) = load(sprintf('visualIN_%02d', net_ID(to_load(iN))));
    end
    
    
end

end