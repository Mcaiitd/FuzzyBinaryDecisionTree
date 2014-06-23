%% function that calculates the index with max entropy
function [index value ] = getEntropyValue(data)
    length = size(data,1);
    values = zeros([length-1 1]);
    for i=1:length-1
        values(i) = entropy(data,i);
    end
    [M I] = max(values);
    y =I ;%max(find(values == M));
    value = (data(y,1) + data(y+1,1))/2;
    index = I;
end

%% function that calculates the entropy for a given index
function [ value ] = entropy(data, i)
    length = size(data,1);
    L = sum(data(1:i,2));
    Lc = sum(1 - data(1:i,2));
    G = sum(data(i+1:length,2));
    Gc = sum(1 - data(i+1:length,2));
    S = L + G;
    Sc = Lc + Gc;
    value = -((L/S)*log2(L/S) + (G/S)*log2(G/S) + (Lc/Sc)*log2(Lc/Sc) + (Gc/Sc)*log2(Gc/Sc));
end