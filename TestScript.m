close all;
clear all;
clc;
addpath('./Libs');

agvRobots = [];
numberOfRobots = 1;


ship = struct();
ship.cargo.types = ["coal","wood","potatoes"];
ship.cargo.quantity = [10,10,10];

storage = struct();
storage.cargo.types = ["coal","wood","potatoes"];
storage.cargo.quantity = [0,0,0];

%% Graph definition - Map

graphData = readtable('./Tables/EdgesList.csv');
nodeA = table2array(graphData(:,3));
nodeB = table2array(graphData(:,4));
weights = table2array(graphData(:,5));

stateList = readtable('./Tables/StateList.csv');
nodeNames = table2array(stateList(:,1));

%%

MapG = digraph(nodeA, nodeB, weights, nodeNames);
path = struct();
[path.nodes, path.length] = shortestpath(MapG, 2, 7); 


path.nodesPairs = [path.nodes(1 : length(path.nodes)-1 )', path.nodes(2 : length(path.nodes) )'];
path.edges = findedge(MapG, path.nodesPairs(:,1), path.nodesPairs(:,2));
MapG.Edges.Weight(path.edges) = MapG.Edges.Weight(path.edges) + 1;

%%
close all;
LWidths = 5*MapG.Edges.Weight/max(MapG.Edges.Weight);
fig = figure(1);
plt = plot(MapG,'EdgeLabel',MapG.Edges.Weight,'LineWidth',LWidths); hold on;
grid minor;
highlight(plt, path.nodes, 'EdgeColor','g');



