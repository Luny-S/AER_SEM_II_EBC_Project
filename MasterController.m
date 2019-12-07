classdef MasterController < handle
    %MASTERCONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mapGraph,
        agvList,
    end
    
    methods
        function obj = MasterController(agvRobotsList)
            %MASTERCONTROLLER Construct an instance of this class
            %   Detailed explanation's not written.
            obj.mapGraph = digraph();
            obj.agvList = agvRobotsList;
        end
        
        function loadMap(obj)
            graphData = readtable('./Tables/EdgesList.csv');
            nodeA = table2array(graphData(:,3));
            nodeB = table2array(graphData(:,4));
            weights = table2array(graphData(:,5));

            stateList = readtable('./Tables/StateList.csv');
            nodeNames = table2array(stateList(:,1));
            obj.mapGraph = digraph(nodeA, nodeB, weights, nodeNames); 
        end
        
        function out = addAgvRobot(obj,agvRobot)
            %ADDAGVROBOT Add a robot to list in the controller
            %   Function adds a robot on the list and returns the total
            %   number of robots on the list.
            obj.AgvList.(agvRobot.Id) = agvRobot;    
            obj.agvCount = length(obj.agvList);
            out = obj.agvCount;
        end
        
        function path = assignPath(obj, agvRobot, task)
            [path.nodes, path.length] = shortestpath(obj.mapGraph, task.startingNode, task.endingNode);
            path.nodesPairs = [path.nodes(1 : length(path.nodes)-1 )', path.nodes(2 : length(path.nodes) )'];
            path.edges = findedge(obj.mapGraph, path.nodesPairs(:,1), path.nodesPairs(:,2));
            
            % Modify path edges weight by +1
            obj.mapGraph.Edges.Weight(path.edges) = obj.mapGraph.Edges.Weight(path.edges) + 1;
                        
            agvRobot.path = path;
        end
        
        function [fig, plt] = plotGraph(obj, fig)
            clf(fig);
            LWidths = 5*obj.mapGraph.Edges.Weight / max(obj.mapGraph.Edges.Weight);
            plt = plot(obj.mapGraph,'EdgeLabel',obj.mapGraph.Edges.Weight,'LineWidth',LWidths); 
            hold on; grid minor;
        end
        
        function highlightPath(obj, plt, path, rgbColor)
            if nargin < 4 % default value
                rgbColor = [rand(), rand(), rand()];
            end
            highlight(plt, path.nodes, 'EdgeColor',rgbColor);
        end
    end
end

