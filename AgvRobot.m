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
        has_product,
        status
    end
    
    methods
        function obj = AgvRobot(id, initState)
            %AGV_ROBOT Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = num2str(id,'AGV_%03.f');
            obj.node = initState;
            obj.status ='WAIT_FOR_TASK';
            obj.action ='STOP';
            obj.priority_move = 0;
            obj.has_product = 0;
            obj.current_node = 'B';
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
        
        function  executeAction(obj,action)    
            if strcmp(action,'MOVE')
                if (length(obj.path.nodes) > 1)
                    obj.path.nodes(1) = [];
                    obj.priority_move = 0;
                    obj.current_node = obj.path.nodes(1);
                elseif ((length(obj.path.nodes)) == 1)
                    obj.current_node = obj.path.nodes(1)
                    obj.path.nodes(1) = [];
                    obj.status ='WAIT_FOR_TASK';
                end
            elseif strcmp(action, 'STOP')
                obj.priority_move =+ 1;
            elseif strcmp(action, 'UNLOAD')
                obj.status = 'WAIT_FOR_TASK';
                obj.has_product = false;
             elseif strcmp(action, 'LOAD')
                obj.status = 'WAIT_FOR_TASK';
                obj.has_product = true;
            end
        end
    end
end

