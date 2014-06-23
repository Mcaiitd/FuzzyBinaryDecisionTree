%%----- Main Program that should be run inorder to execute the code -----%%

% load the data file
load('earfeature15window700image.mat');


% Change following variable in case of number of user changes
noOfUsers = 100;

% Change following two variable in case you need to change ration of test
% and train case or when the number of data value for same user changes(right now its 7)
trainCasePerUser = 4;
testCasePerUser = 3;

if(testCasePerUser < 2)
    disp('testCasePerUser should be greater then 1')
    
else  

totalCasePerUser = trainCasePerUser + testCasePerUser;

% 3D matrix where 1st dimention is related the user, 2nd dimention related
% to datavalues per user and 3rd dimention are the feature values for datapoints 
test = zeros([noOfUsers testCasePerUser 35]);
train = zeros([noOfUsers trainCasePerUser 35]);

%% this loop devides the data into testcases and trainingcase randomly
for i=1:noOfUsers
    
   % matrix p is the random permutation of interger 1 to total number of datavalues per user  
   p = randperm(totalCasePerUser,totalCasePerUser);
   
   % below two lines divide the data into tests and training data
   test(i,:,:) = T_S1(:,(i-1)*totalCasePerUser + p(1:testCasePerUser))';
   train(i,:,:) = T_S1(:,(i-1)*totalCasePerUser + p(testCasePerUser+1:totalCasePerUser))';
end

%% Following piece of code find creates the matching score matrix with 2 columns 
% 1st column has the value of matching score and 2nd column has value 1 if 
% its genuine and 0 if imposter
trainScore = zeros([noOfUsers*noOfUsers 2]);
testScore = zeros([noOfUsers*noOfUsers*(testCasePerUser-1) 2]);

% loop that creates the matrix of training sample.
for i=1:noOfUsers
    for j=1:noOfUsers
        score = zeros([trainCasePerUser 1]);
        for k = 1:trainCasePerUser
            score(k) = norm(squeeze((test(i,1,:) - train(j,k,:))),2);
        end
        
        % take the min of distance to get the matching score
        trainScore((i-1)*noOfUsers + j,1) = min(score);
        
        %  if the users are same then its genuine class else imposter
        if(i==j)
            trainScore((i-1)*noOfUsers + j,2) = 1;
        else
            trainScore((i-1)*noOfUsers + j,2) = 0;
        end        
    end
end

% loop that creates the matrix of testing sample
for z=0:testCasePerUser-2
    for i=1:noOfUsers
        for j=1:noOfUsers
            score = zeros([trainCasePerUser 1]);
            for k = 1:trainCasePerUser
                score(k) = norm(squeeze((test(i,z+2,:) - train(j,k,:))),2);
            end
            testScore(z*noOfUsers*noOfUsers + (i-1)*noOfUsers + j,1) = min(score);
            if(i==j)
                testScore(z*noOfUsers*noOfUsers + (i-1)*noOfUsers + j,2) = 1;
            else
                testScore(z*noOfUsers*noOfUsers + (i-1)*noOfUsers + j,2) = 0;
            end        
        end
    end
end

% find the geninue class datapoint and put them in Gtrain Matrix
Gtrain = trainScore(find(trainScore(:,2) == 1), :);

% find the imposter class datapoint and put them in Itrain Matrix
Itrain = trainScore(find(trainScore(:,2) == 0), :);

% Create the final training matrix with  score value in 1st column, membership 
% value in 2nd column and class in 3rd column for creating dicision tree.
% change the membership function 2nd  column in case you want to use
% different membership funtion
Mtrain = [Gtrain(:,1) GaussianMembership(Gtrain(:,1)) Gtrain(:,2); Itrain(:,1) TrapezoidalMembership(Itrain(:,1)) Itrain(:,2)];
%Mtrain = [Gtrain(:,1) TrapezoidalMembership(Gtrain(:,1)) Gtrain(:,2); Itrain(:,1) TrapezoidalMembership(Itrain(:,1)) Itrain(:,2)];

%% This part of code deals with growing the decision tree

% sort the training matrix according the matching score value.
[a b] = sort(Mtrain(:,1));
clear a;
data = Mtrain(b,:);

% grow the tree using sorted training matrix
tree = growTree( data );

%% This part of code deals with the predicting the class of testing score and
% calculation of FRR and FAR
testingSize = noOfUsers*noOfUsers*(testCasePerUser-1);
geniuneTestingSize = noOfUsers*(testCasePerUser-1);
trainingSize = noOfUsers*noOfUsers;
geniuneTrainingSize = noOfUsers;

pre = zeros([testingSize 2]);

% loop that predicts the values of all testing data
for i=1:testingSize
    pre(i,1) = predict(tree, testScore(i,:));
    pre(i,2) = testScore(i,2);
end

% calculation of FAR and FRR
FA = pre(find(pre(:,1) == 1 & pre(:,2) == 0),:); % False Acceptance
FR = pre(find(pre(:,1) == 0 & pre(:,2) == 1),:); % False Rejection
FAR = size(FA,1)/(testingSize-geniuneTestingSize); % False Acceptance Rate
FRR = size(FR,1)/geniuneTestingSize; % False Rejection Rate

%% histgram of normalized frequencies of matching score of Geniune and Imposter matching score
figure;
[m,yout] = hist(Itrain(:,1), 20);
m = m/(size(Itrain,1));
[n,xout] = hist(Gtrain(:,1), 20);
n = n/size(Gtrain,1);
bar(yout,m);
hold on;
bar(xout,n, 'r');
legend('Imposter Scores','Geniune Scores');
hold off;
end