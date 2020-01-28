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

shipsDefinitionFile = "Ships.json";
ships = readJsonFile(shipsDefinitionFile);


ship_quantity_all = 0;
for i = 1: length(ships)
   ship_quantity_all = ship_quantity_all + ships(i).cargo.quantity;
end
storage = struct();
storage.cargo.types = ["A","B","C"]; % 'ST1', 'ST2', 'ST3'
storage.cargo.quantity = [0,0,0];

fig = figure();

stepNumber = 1;
while ~system_status
    
    step = struct();
    step.number = stepNumber;
    step.robots = [];
     for iter = 1:numberOfRobots
         agv_name = (num2str(iter,'AGV_%03.f'));
         robot = agvRobotsList.agvRobots.(agv_name);
         quantity_high = 0;
         ship_id = -1;
         %fprintf("%s status: %s. \n", agv_name ,robot.status)
         
         
         
        if strcmp(robot.status,'WAIT_FOR_TASK')
                for i = 1: length(ships)
                   if  ((ships(i).cargo.quantity - ships(i).cargo.reserved) > 0 )
                       quantity = ships(i).cargo.quantity - ships(i).cargo.reserved;
                   else
                       quantity = ships(i).cargo.quantity; 
                   end
                    if quantity_high < quantity
                        quantity_high = quantity;
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
                                ships(i).cargo.quantity = ships(i).cargo.quantity- 1;
                                ships(i).cargo.reserved = ships(i).cargo.reserved - 1;
                                ship_id = -1;
                            end
                        end
                    end 
                end
                if ship_id ~= -1
                    ships(ship_id).cargo.reserved = ships(ship_id).cargo.reserved + 1
                end
            if quantity_high <= 0 
                if  ~strcmp(robot.current_node, 'B')
                 task.startingNode = robot.current_node;
                 task.endingNode =  'B';
                else
                    robots_in_base = robots_in_base + 1;
                    continue;
                end
            end
           controller.assignPath(robot, task);
        end
        agvRobotsList.agvRobots.(agv_name) = robot;
        action = controller.getAction(robot);
        fprintf("%s action: %s , status: %s. \n", agv_name ,action, robot.status)

        agvRobotsList.agvRobots.(agv_name).executeAction(action);
        controller.updateOcuppancyGrid(robot.current_node,agvRobotsList.agvRobots.(agv_name).current_node);
        if strcmp(action, 'UNLOAD')
            id_num = str2double(extractAfter(robot.current_node(1),'ST'));
            storage.cargo.quantity(id_num) = storage.cargo.quantity(id_num) +1;
        end
        
        % HERE ONE STEP FOR ONE ROBOT POSE IS UPDATEDED
        % Step data for JSON write function
        robotData = struct();
        % Works because at the beginning of loop we get robot by
        % transforming iter to form AGV_%03.f
        robotData.id = iter;
        robotData.location = char(robot.current_node);
        robotData.path = [];

        pathData = char(robot.path.nodes);
        pathSize = size(robot.path.nodes);
        for i = 1:pathSize(2)
           robotData.path =  [robotData.path, find(controller.mapGraph.Nodes.Name == string(strtrim(pathData(i,:))))];
        end
        step.robots = [step.robots, robotData];
         
        [fig, plt] = controller.plotGraph(fig);
        controller.highlightPath(plt,agvRobotsList.agvRobots.(agv_name).path);
     end
     pause(0.2)  %
        % HERE  ONE STEP FOR ALL ROBOT POSE IS UPDATEDED
        
        
     %% Open JSON file and save
     dataFileName = "symulacja.json";
     file = dir(dataFileName);
     if ~isempty(file) && ~file.isdir  % File is existing:
        data = readJsonFile(dataFileName);
        if length(data.steps) > stepNumber
            data.steps = [];
        end
     else                              % File is missing:
        data = struct();
        data.steps = [];        
     end
     %%
     data.steps = [data.steps; step];
     writeJsonFile(dataFileName, data);
     %%
    %%
     stepNumber = stepNumber + 1;

     if (robots_in_base == numberOfRobots)
        system_status = true;
     end
     robots_in_base = 0;
end

for iter = 1:numberOfRobots
 agv_name = (num2str(iter,'AGV_%03.f'));
 disp(agvRobotsList.agvRobots.(agv_name).current_node);
end
disp(storage.cargo.quantity)


