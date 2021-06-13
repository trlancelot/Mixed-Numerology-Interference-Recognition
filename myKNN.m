clear;close all;clc;
[x_train,y_train,x_test,y_test] = dataProcessforSVM;

% knnmodel = fitcknn(x_train,y_train,'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',...
%     struct('AcquisitionFunctionName','expected-improvement-plus'));

load('knnmodel')
label = predict(knnmodel,x_test);
accuracy = sum(label == y_test)/numel(y_test);