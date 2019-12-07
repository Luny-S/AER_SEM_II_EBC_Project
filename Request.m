classdef Request
    %REQUEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type, 
        content,
        response
    end
    
    methods
        function obj = Request()
            %REQUEST Construct an instance of this class
            %   Detailed explanation goes here
            obj.type = 'Empty'; % ( Empty | NewPath | NodePermission )
            obj.content = struct();
            obj.response = struct();
        end
    end
end

