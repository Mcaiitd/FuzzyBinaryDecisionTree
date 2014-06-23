%% funtion that gives the value of index for which the giniValue is  highest
function [index value ] = getGiniValue(data)
    length = size(data,1);
    values = zeros([length-1 1]);
    for i=1:length-1
        values(i) = gini(data,i);
    end
    [M I] = min(values);
    y =I ;%max(find(values == M));
    value = (data(y,1) + data(y+1,1))/2;
    index = I;
end

%% function that calculates the gini value for a given index
function [ value ] = gini(data, i)
    length = size(data,1);
    L1 = sum(data(find(data(1:i,3)==0),2));
    L2 = sum(data(find(data(1:i,3)==1),2));
    G1 = sum(data(find(data(i+1:length,3)==0),2));
    G2 = sum(data(find(data(i+1:length,3)==1),2));
    S = L1+L2+G1+G2;
    value = ((L1+L2)/S)*(1 - (L1/(L1+L2))^2 - (L2/(L1+L2))^2) + ((G1+G2)/S)*(1 - (G1/(G1+G2))^2 - (G2/(G1+G2))^2);
end