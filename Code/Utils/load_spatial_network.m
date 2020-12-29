function [postSyn, preSynEX, preSynIN]= load_spatial_network(ID, path)
% loads the source data for spatial and visual presynaptic distributions]
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
    cd(fullfile(path, 'Data'))
else
    cd('C:\Users\Federico\Documents\GitHub\Rossi-et-al-2020\Data');
end

post_list = dir('*postSyn*.mat');
net_list_EX = dir('*spatialEX*.mat');
net_list_IN = dir('*spatialIN*.mat');

net_ID = str2double(regexp({post_list.name}, '\d{2}', 'match', 'once'));

if ID =='all'
    
    to_load = 1:numel(net_ID);
else
    [~, to_load] = intersect(net_ID, ID);
end


for iN = 1:numel(to_load)
        
    preSynEX(iN) = load(net_list_EX(to_load(iN)).name);
    preSynIN(iN) = load(net_list_IN(to_load(iN)).name);
    postSyn(iN) = load(post_list(to_load(iN)).name);
    
end


end