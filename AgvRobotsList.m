classdef AgvRobotsList < handle
    %AGVROBOTSLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        agvRobots,
        agvCount
    end
    
    methods
        function obj = AgvRobotsList()
            %AGVROBOTSLIST Construct an instance of this class
            %   Detailed explanation goes here
            obj.agvRobots = struct();
            obj.agvCount = 0;
        end
        
        function obj = addAgvRobot(obj,agvRobot)
            %ADDAGVROBOT Adds AGV robot to the robots list.
            %   Detailed explanation goes here
            obj.agvRobots.(agvRobot.id) = agvRobot;
            obj.agvCount = obj.agvCount + 1; 
        end
    end
end

