classdef AgvRobotFactory < handle
    %AGVROBOTFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        agvCount
    end
    
    methods
        function obj = AgvRobotFactory()
            %AGVROBOTFACTORY Construct an instance of this class
            %   Detailed explanation goes here
            obj.agvCount = 0;
        end
        
        function agvRobot = makeAgvRobot(obj, initState)
            if nargin < 2 % default value
                initState = 1;
            end
            obj.agvCount = obj.agvCount + 1; 
            agvRobot = AgvRobot(obj.agvCount, initState);
        end
        
        function agvRobotsList = makeAgvRobotsList(obj, robotsNumber, initState)
            agvRobotsList = AgvRobotsList();
            if nargin < 3 % default value
                initState = 1;
            end
            
            for i=1:1:robotsNumber
                agvRobotsList.addAgvRobot(obj.makeAgvRobot(initState));
            end
        end
    end
end

