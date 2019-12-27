classdef AgvRobot < handle
    %AGV_ROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id,
        current_node,
        node, % or used last elem in path
        path,
        action, % MOVE or STOP
        priority_move,
        status
    end
    
    methods
        function obj = AgvRobot(id, initState)
            %AGV_ROBOT Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = num2str(id,'AGV_%03.f');
            obj.node = initState;
            obj.status ="WAIT_FOR_TASK";
            obj.priority_move = 0;
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
        
        function action = executeAction(obj,act, path)
            if isempty(obj.path)
                obj.path = path;
            end
            if strcmp(act,'MOVE')
                obj.current_node = obj.path(1);
                obj.path(1) = [];
            end
        end
        
        function status = getStatus(obj)
            if isempty(obj.path) == 0
                obj.status = "WAIT_FOR_TASK";
            else
                obj.status = "WAIT_FOR_PERMISSION_MOVE";             
            end
        end

    end
end

