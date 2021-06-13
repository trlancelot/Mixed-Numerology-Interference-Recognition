clear;
length=250;
% load('datafft_c25_30.mat');
load('cnn_test_data_25.mat');
Data=Data(:,1:length);
[m,~]=size(Data);
data=zeros(2,length,1,m);
X1=zeros(2,length);
for i=1:m
    for j=1:length
       X1(1,j)=real(Data(i,j));
       X1(2,j)=imag(Data(i,j));
%        X1(1,j)=abs(Data(i,j));
%        X1(2,j)=angle(Data(i,j));
    end
    data(:,:,1,i)=X1;
end
X_test=data;y_test=categorical(label);
load('tempmodel.mat');
[YPred,~] = classify(net,X_test);
accuracy = sum(YPred == y_test)/numel(y_test);