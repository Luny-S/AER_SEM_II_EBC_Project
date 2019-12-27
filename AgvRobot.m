classdef AgvRobot < handle
    %AGV_ROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id,
        current_node,
        node, % or used last elem in path
        path,
        action, % MOVE or STOP
        status
    end
    
    methods
        function obj = AgvRobot(id, initState)
            %AGV_ROBOT Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = num2str(id,'AGV_%03.f');
            obj.node = initState;
            obj.path = [];
        end
        
        function request = makeRequest(obj)
            %MAKEREQUEST Make request to the main controller
            %   Detailed explanation goes here
            request = Request();
            
            if isempty(obj.path) == 0
                request.type = 'NewPath';
                request.content.task = '';
            end
            
        end
    end
end

