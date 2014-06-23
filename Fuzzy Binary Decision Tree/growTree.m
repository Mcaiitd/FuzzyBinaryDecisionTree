%% function that grows the Decision Tree
% here output would be sturcture if node is not a leafnode, the structure
% contain three variable "value" which is value of matching score which
% will be decision criterion while predicting value of testscore, "L" reference 
% to left subtree,"G" reference to right subtree. If this is leaf node tree
% would be an integer 0 or 1 which is the predicted class on that node
function [ tree ] = growTree( data )

    % check the stopping criterion for the data
    stop = stoppingCriteria(data);
    if(stop == 2) % if stopping criterion 2 the grow tree further
        
        % get the index and matching score about which tree will be subdivided
        [index value] = getEntropyValue(data);
        length = size(data,1);
        disp(length);
        
        % divide the data for left and right subtree
        dataL = data(1:index,:);
        dataG = data(index:length-1,:);
        
        % grow  the left and rightsubtree using the left and right data
        tree = struct('value', value, 'L', growTree(dataL), 'G', growTree(dataG));
    else % else value of tree would be the stopping criterion which is the value of class at this leaf node
        tree = stop;
    end
end

