classdef Storage
    %STORAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type,
        quantity
    end
    
    methods
        function obj = Storage(type, init_quantity)
            %STORAGE Construct an instance of this class
            %   Detailed explanation goes here
            obj.type = type;
            obj.quantity = init_quantity;
        end
        
        function add = add(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.quantity =+ inputArg
        end
    end
end

