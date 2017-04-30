function Result = svm_cv()

%clear ; close all; clc

%fprintf('\nInitializing SVM Parameters ...\n')

data_fights     = csvread('VIF-IRLS_svv_fight_50(SS-3).csv');  %100 X 40
data_nofights   = csvread('VIF-IRLS_svv_no_fight_50(SS-3).csv');  %100 X 40

[a, b] = size(data_fights);
[c, d] = size(data_nofights);

X               = [data_fights; data_nofights];

%Y_fights    = ones(a,1);
%Y_nofights  = zeros(c,1);
%Y_nofights  = Y_nofights-1;
Y_fights = cell(a, 1);
Y_fights(:) = {'fights'};
Y_nofights = cell(c, 1);
Y_nofights(:) = {'nofights'};

Y = [Y_fights; Y_nofights];

%# number of cross-validation folds:
%# If you have 50 samples, divide them into 10 groups of 5 samples each,
%# then train with 9 groups (45 samples) and test with 1 group (5 samples).
%# This is repeated ten times, with each group used exactly once as a test set.
%# Finally the 10 results from the folds are averaged to produce a single 
%# performance estimation.

k=10;

cvFolds = crossvalind('Kfold', Y, k);   %# get indices of 10-fold CV
cp = classperf(Y);                      %# init performance tracker

ErrorR = [];

for i = 1:k                                  %# for each fold
    testIdx = (cvFolds == i);                %# get indices of test instances
    trainIdx = ~testIdx;                     %# get indices training instances

    %# train an SVM model over training instances
    options.MaxIter = 1000000;
    svmModel = svmtrain(X(trainIdx,:), Y(trainIdx), 'Options', options);
    %svmModel = svmtrain(X(trainIdx,:), Y(trainIdx));

    %# test using test instances
    pred = svmclassify(svmModel, X(testIdx,:));
    
    %ErrorR  = [ ErrorR; sum(Y(testIdx,:) ~= pred) / length(Y(testIdx,:))  ];

    %# evaluate and update performance object
    cp = classperf(cp, pred, testIdx);
end

%CorrectRate = 1 - mean(ErrorR)

%# get accuracy
Result = cp.CorrectRate;

%# get confusion matrix
%# columns:actual, rows:predicted, last-row: unclassified instances
cp.CountingMatrix;

end