%% function that returns the Trapezoidal membership value of set of matching score
function [Y] = TrapezoidalMembership(X)

a = min(X);
b = max(X);
m = mean(X);
d = std(X);

alpha = a;
beta = m - d;
gamma = m + d;
delta = b;
Y = zeros([size(X,1) 1]);
for i=1:size(X,1)
    if(X(i)<a)
        Y(i) = 0;
    elseif(X(i)>=a && X(i)<=beta)
        Y(i) = (X(i)-a)/(beta-alpha);
    elseif(X(i)>=beta && X(i)<=gamma)
        Y(i) = 1;
    elseif(X(i)>=gamma && X(i)<=delta)
        Y(i) = (delta-X(i))/(delta-gamma);
    elseif(X(i) > delta)
        Y(i) = 0;
    end
end
figure
plot(X,Y,'.b');
end

