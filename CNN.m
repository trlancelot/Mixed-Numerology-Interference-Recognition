clear;clc;close all;
layers = [imageInputLayer([2 250 1]);
          convolution2dLayer([2 20],50,'Padding','same');
          batchNormalizationLayer
          reluLayer();
          dropoutLayer;
          
          convolution2dLayer([1 3],10,'Padding','same');
          batchNormalizationLayer
          reluLayer();
          dropoutLayer;
          
          averagePooling2dLayer([1 5],'Stride',5,'Padding','same');
          
          fullyConnectedLayer(100);
          reluLayer();
          fullyConnectedLayer(25);
          reluLayer();
          fullyConnectedLayer(2);
          softmaxLayer;
          classificationLayer];
 options = trainingOptions('adam','MaxEpochs',30,...
    'InitialLearnRate',0.001,'Plots','training-progress');
 
[X_train,y_train,X_test,y_test]=dataProcessforcnn;

[net,traininfo] = trainNetwork(X_train,y_train,layers,options);
[YPred,~] = classify(net,X_test);
accuracy = sum(YPred == y_test)/numel(y_test);