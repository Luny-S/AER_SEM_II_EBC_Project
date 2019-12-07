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
controller.assignPath(agvRobotsList.agvRobots.AGV_001, task);


%%
% for iteration = 1 : 1 : programSteps
%    % robots asks for permissions or new path
%    % master controller evaluates requests
%    % robots make actions
% end

fig = figure();
[fig, plt] = controller.plotGraph(fig);
controller.highlightPath(plt,agvRobotsList.agvRobots.AGV_001.path);

% ship = struct();
% ship.cargo.types = ["coal","wood","potatoes"];
% ship.cargo.quantity = [10,10,10];
% storage = struct();
% storage.cargo.types = ["coal","wood","potatoes"];
% storage.cargo.quantity = [0,0,0];
