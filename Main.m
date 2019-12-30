%%
close all;
clear all;
pause on;
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
task.startingNode = 'ST3';
task.endingNode = 'SH1';

%% Task assignment test
%controller.assignPath(agvRobotsList.agvRobots.AGV_001, task);
fig = figure();
for iteration = 1 : 1 : 8
     for iter = 1:numberOfRobots
         agv_name = (num2str(1,'AGV_%03.f'));
         robot = agvRobotsList.agvRobots.(agv_name);
         %TODO put it to MasterController
        if strcmp(robot.status,'WAIT_FOR_TASK')
            controller.assignPath(robot, task);
        end
        agvRobotsList.agvRobots.(agv_name) = robot;
        action = controller.getAction(robot);
        agvRobotsList.agvRobots.(agv_name).executeAction(action);
        controller.updateOcuppancyGrid(robot.current_node,agvRobotsList.agvRobots.(agv_name).current_node);
        pause(0.1)
     end
     
    % robots asks for permissions or new path
%    % master controller evaluates requests
%    % robots make actions
    [fig, plt] = controller.plotGraph(fig);
    controller.highlightPath(plt,agvRobotsList.agvRobots.AGV_001.path);
end
fig2 = figure();
[fig2, plt] = controller.plotGraph(fig2);
controller.highlightPath(plt,robot.path);

% ship = struct();
% ship.cargo.types = ["coal","wood","potatoes"];
% ship.cargo.quantity = [10,10,10];
% storage = struct();
% storage.cargo.types = ["coal","wood","potatoes"];
% storage.cargo.quantity = [0,0,0];
