clear;close all;clc;
[x_train,y_train,x_test,y_test] = dataProcessforSVM;

% treemodel = fitctree(x_train,y_train,'OptimizeHyperparameters','auto');
load('treemodel');
label = predict(treemodel,x_test);
accuracy = sum(label == y_test)/numel(y_test);