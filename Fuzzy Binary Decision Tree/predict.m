% function that predicts the class for given value of a matching score
% input is the tree and value of score

function [ value ] = predict( tree, x )

    % if the tree is structure, compare the value of x with the matching
    % score value of node
    if(isstruct(tree))
        if(x(1) < tree.value) % if x is less then score value of node goto left subtree
           value = predict(tree.L,x(1));
        else % else goto right subtree
           value = predict(tree.G,x(1));
        end
    else % if tree not stucture its value would be the predicted value of x
        value = tree;
    end


end

