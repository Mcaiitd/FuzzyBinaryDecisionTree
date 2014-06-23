%% function that returns the gaussian membership value of set of matching score
function [Y] = GaussianMembership(X)

a = min(X);
b = max(X);
m = mean(X);
d = std(X);

Y = exp(-((X-m).*(X-m))/(2*d*d));

for i = 1:size(X)
    if(X(i)<a || X(i)>b)
        Y(i) = 0;
    end
end
figure
plot(X,Y,'.b');
end