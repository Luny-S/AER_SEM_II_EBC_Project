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

%Simplified ship and storage
ship_1 = struct();
ship_1.cargo.types = 'C';
ship_1.cargo.dock = 'SH1';
ship_1.cargo.quantity = 10;
ship_2 = struct();
ship_2.cargo.types = 'A';
ship_2.cargo.dock = 'SH2';
ship_2.cargo.quantity = 5;
ship_3 = struct();
ship_3.cargo.types = 'B';
ship_3.cargo.dock = 'SH3';
ship_3.cargo.quantity = 1;
ships = [ship_1,ship_2,ship_3];



storage = struct();
storage.cargo.types = ["A","B","C"]; % 'ST1', 'ST2', 'ST3'
storage.cargo.quantity = [0,0,0];

fig = figure();
status = false
while ~status
     for iter = 1:numberOfRobots
         agv_name = (num2str(1,'AGV_%03.f'));
         robot = agvRobotsList.agvRobots.(agv_name);

        if strcmp(robot.status,'WAIT_FOR_TASK')
            quantity_high = 0;
            for i = 1: length(ships)
                if quantity high < ships(i).cargo.quantity
                    quantity_high = ships(i).cargo.quantity;
                    task.startingNode = robot.current_node;
                    task.endingNode =  ships(i).cargo.dock;
                end
            end
            if ismember(['SH1','SH2','SH3'],robot.current_node)
                for i = 1: length(ships)
                    if ships(i).cargo.dock == robot.current_node
                        if ships(i).cargo.quantity > 0 
                            task.startingNode = robot.current_node;
                            index = find(storage.cargo.types == ships(i).cargo.types)
                            task.endingNode = num2str(index,'ST%i') 
                            robot.has_product = true;
                            ships(i).cargo.quantity =- 1;
                            
                        end
                    end
                end
         
            end
            controller.assignPath(robot, task);
        end
        agvRobotsList.agvRobots.(agv_name) = robot;
        action = controller.getAction(robot);
        agvRobotsList.agvRobots.(agv_name).executeAction(action);
        controller.updateOcuppancyGrid(robot.current_node,agvRobotsList.agvRobots.(agv_name).current_node);
        pause(1)
     end
     

    % robots asks for permissions or new path
    % master controller evaluates requests
    % robots make actions
    [fig, plt] = controller.plotGraph(fig);
    controller.highlightPath(plt,agvRobotsList.agvRobots.AGV_001.path);
end

