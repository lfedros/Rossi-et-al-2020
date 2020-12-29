function [postSyn, preSynEX, preSynIN]= load_network(ID, path)

if nargin == 2
    cd(path)
else
    cd('C:\Users\Federico\Documents\GitHub\Rossi-et-al-2020\Data');
end

net_list = dir('*.mat');

net_ID = str2double(regexp({net_list.name}, '\d{2}', 'match', 'once'));

if ID =='all'
    
    to_load = 1:numel(net_ID);
else
    [~, to_load] = intersect(net_ID, ID);
end


for iN = 1:numel(to_load)
    
    network(iN) = load(net_list(to_load(iN)).name);
    
    preSynEX(iN) = network(iN).preSynEX;
    preSynIN(iN) = network(iN).preSynIN;
    postSyn(iN) = network(iN).postSyn;
    
end


end