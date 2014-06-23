function [ h ] = height( tree )
    if(isstruct(tree.L))
        h1 = height(tree.L);
    else
        h1 = 1;
    end
    if(isstruct(tree.G))
        h2 = height(tree.G);
    else
        h2 = 1;
    end
    h = 1 + max(h1,h2);
end

