%% function that tells gives output as follow
% 0 if the growing tree should be stopped and class value should be
% imposter at the node this function is called, 1 if grow tree should be
% stopped and class be genuine, 2 if we should continue growing tree

function [ret] = stoppingCriteria(X)
    if(size(X,1) == 1)
    ret = X(1,3);
    else
        
    % below are the two parameters for stopping criterion of the algorithm
    threshold1 = 0.9995; % this one deals with the ratio of sum of membership values of imposter and genuine scores to total sum of membership values.
    threshold2 = 1.0; % this one deals with sum of membership values of all scores  in data
    k1=1;k2=1;
    Y1=[];Y2=[];
    for i = 1:size(X,1)

    if(X(i,3)==1)
        Y1(k1) = X(i,2);
        k1=k1+1;
    else
        Y2(k2) = X(i,2);
        k2=k2+1;
    end

    end

    sumTotal = sum(X(:,2));
    sum1 = sum(Y1);
    sum2 = sum(Y2);

    ratio1 = sum1/sumTotal; % ratio of sum of membership values of ginuine class to total sum
    ratio2 = sum2/sumTotal; % ratio of sum of membership values of imposter class to total sum

    
    if(ratio1>=threshold1) % return 1 i.e class of node is genuine
        ret =1;
    elseif (ratio2>=threshold1) % return 0 i.e class of node is imposter
        ret =0;
    elseif (sumTotal <= threshold2) % retrun 0 or depending upon which class ration is higher
        ret = ratio1>ratio2;
    else % return 2 to keep growing the tree
       ret = 2;
    end
    end
 end
