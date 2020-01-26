%%
close all;
clear all;
pause on;
clc;
addpath('./Libs');

%% Program parameters
numberOfRobots = 3;
initialState = 1;
programSteps = 20;
ships_unloaded = false;
system_status = false;
robots_in_base = 0;
unload_correctness = false;

%% AGV robots list construction
RobotFactory = AgvRobotFactory();
agvRobotsList = RobotFactory.makeAgvRobotsList(numberOfRobots, initialState);

%% Controller construction
controller = MasterController(agvRobotsList);
controller.loadMap();
%% Test task
task = struct();
%task.name = 'getWood';
%task.startingNode = 'ST3';
%task.endingNode = 'SH1';

%Simplified ship and storage
ship_1 = struct();
ship_1.cargo.types = 'C';
ship_1.cargo.dock = 'SH1';
ship_1.cargo.quantity =4;
ship_1.cargo.reserved = 0;
ship_2 = struct();
ship_2.cargo.types = 'A';
ship_2.cargo.dock = 'SH2';
ship_2.cargo.quantity =1;
ship_2.cargo.reserved = 0;
ship_3 = struct();
ship_3.cargo.types = 'B';
ship_3.cargo.dock = 'SH3';
ship_3.cargo.quantity = 2;
ship_3.cargo.reserved = 0;
ships = [ship_1,ship_2,ship_3];
ship_quantity_all = 0;
for i = 1: length(ships)
   ship_quantity_all = ship_quantity_all + ships(i).cargo.quantity;
end
storage = struct();
storage.cargo.types = ["A","B","C"]; % 'ST1', 'ST2', 'ST3'
storage.cargo.quantity = [0,0,0];

fig = figure();

while ~system_status
     for iter = 1:numberOfRobots
         agv_name = (num2str(iter,'AGV_%03.f'));
         robot = agvRobotsList.agvRobots.(agv_name);
         quantity_high = 0;
         ship_id = -1;
       %  fprintf("%s status: %s. \n", agv_name ,robot.status)
        if strcmp(robot.status,'WAIT_FOR_TASK')
                for i = 1: length(ships)
                    if quantity_high < (ships(i).cargo.quantity - ships(i).cargo.reserved)
                        quantity_high = ships(i).cargo.quantity - ships(i).cargo.reserved;
                        task.startingNode = robot.current_node;
                        task.endingNode =  ships(i).cargo.dock;
                        ship_id = i;
                    end
                end
                if (any(strcmp({'SH1','SH2','SH3'},robot.current_node)))
                    for i = 1: length(ships)
                        if strcmp(ships(i).cargo.dock,robot.current_node)
                            if ships(i).cargo.quantity > 0 
                                task.startingNode = robot.current_node;
                                quantity_high = ships(i).cargo.quantity;
                                index = find(storage.cargo.types == ships(i).cargo.types);
                                task.endingNode = num2str(index,'ST%i') ;
                                ships(i).cargo.quantity =- 1;
                                ships(i).cargo.reserved = ships(i).cargo.reserved - 1;
                                ship_id = -1;
                            end
                        end
                    end 
                end
                if ship_id ~= -1
                    ships(ship_id).cargo.reserved = ships(ship_id).cargo.reserved + 1
                end
                if quantity_high <= 0 && ~strcmp(robot.current_node, 'B')
                    task.startingNode = robot.current_node;
                     task.endingNode =  'B';
                end
           controller.assignPath(robot, task);
        end
        agvRobotsList.agvRobots.(agv_name) = robot;
        action = controller.getAction(robot);
        agvRobotsList.agvRobots.(agv_name).executeAction(action);
        controller.updateOcuppancyGrid(robot.current_node,agvRobotsList.agvRobots.(agv_name).current_node);
        if strcmp(action, 'UNLOAD')
            id_num = str2double(extractAfter(robot.current_node(1),'ST'));
            storage.cargo.quantity(id_num) = storage.cargo.quantity(id_num) +1;
        end
        suma = sum(storage.cargo.quantity, 'all');
        
        for i = 1: length(ships)
            suma = suma + ships(i).cargo.reserved;
        end
        if ship_quantity_all == suma
            ships_unloaded = true;
        end
        
        if strcmp(agvRobotsList.agvRobots.(agv_name).current_node, 'B') && ships_unloaded
            robots_in_base = robots_in_base + 1;
        end
        
        % HERE ONE STEP FOR ONE ROBOT POSE IS UPDATEDED
          
        [fig, plt] = controller.plotGraph(fig);
        controller.highlightPath(plt,agvRobotsList.agvRobots.(agv_name).path);
     end
        % HERE  ONE STEP FOR ALL ROBOT POSE IS UPDATEDED

     if (robots_in_base == numberOfRobots)
        system_status = true;
     end
     robots_in_base = 0;
end

for i = 1: length(ships)
   disp( ships(i).cargo.quantity);
end
disp(storage.cargo.quantity)
%for iter = 1:numberOfRobots
%         agv_name = (num2str(iter,'AGV_%03.f'));
%         disp(agvRobotsList.agvRobots.(agv_name).current_node);
%end
