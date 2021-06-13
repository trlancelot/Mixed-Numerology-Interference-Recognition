clear;close all;clc;
[x_train,y_train,x_test,y_test] = dataProcessforSVM;
% [X_train, mu, sigma] = featureNormalize(x_train);
% 
% X_test=bsxfun(@minus, x_test, mu);
% X_test=bsxfun(@rdivide, X_test, sigma);

% svmmodel = fitcsvm(x_train,y_train,'KernelFunction','gaussian','OptimizeHyperparameters','auto', ...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName', ...
%     'expected-improvement-plus'));
load('svmmodel')
label = predict(svmmodel,x_test);
accuracy = sum(label == y_test)/numel(y_test);