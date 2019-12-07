%%
close all;
clear all;
clc;
addpath('./Libs');

%% Program parameters
numberOfRobots = 1;
initialState = 1;
programSteps = 20;

%% AGV robots list construction
RobotFactory = AgvRobotFactory();
agvRobotsList = RobotFactory.makeAgvRobotsList(numberOfRobots, initialState);

%% Controller construction
controller = MasterController(agvRobotsList);
controller.loadMap();

%% Test task
task = struct();
task.name = 'getWood';
task.startingNode = 1;
task.endingNode = 2;

%% Task assignment test
% controller.assignPath();


%%
% for iteration = 1 : 1 : programSteps
%    % robots asks for permissions or new path
%    %%
%    
%    % master controller evaluates requests
%    
%    
%    % robots make actions
%     
%    
% end

fig = figure();
controller.plotGraph(fig);

% highlight(plt, path.nodes, 'EdgeColor','g');

% 
% ship = struct();
% ship.cargo.types = ["coal","wood","potatoes"];
% ship.cargo.quantity = [10,10,10];
% 
% storage = struct();
% storage.cargo.types = ["coal","wood","potatoes"];
% storage.cargo.quantity = [0,0,0];
% 
% %% Graph definition - Map
% 
% graphData = readtable('./Tables/EdgesList.csv');
% nodeA = table2array(graphData(:,3));
% nodeB = table2array(graphData(:,4));
% weights = table2array(graphData(:,5));
% 
% stateList = readtable('./Tables/StateList.csv');
% nodeNames = table2array(stateList(:,1));
% 
% 
% 
% 
% 
