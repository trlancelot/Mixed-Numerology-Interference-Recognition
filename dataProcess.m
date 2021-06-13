function [X_train,y_train,X_test,y_test,X_test_,y_test_]=dataProcess
    length=500;
    load('newdata.mat');
%     l=1:2208;
%     stem(l*3072/2208,abs(fft(Data(1,:),2208)));
    Data=Data(:,1:length/2);
    [m,n]=size(Data);
    X1=zeros(m,2*n);
    for i=1:m
        for j=1:n
           X1(i,2*j-1)=real(Data(i,j));
           X1(i,2*j)=imag(Data(i,j));
%            X1(i,2*j-1)=abs(Data(i,j));
%            X1(i,2*j)=angle(Data(i,j));
        end
    end
    X_train=X1(1:14000,:);y_train=label(1:14000,:);
    data_train=[X_train,y_train];
    rng(sum(100*clock));
    rowrank=randperm(size(data_train,1));
    data_train=data_train(rowrank,:);

    X_train=data_train(:,1:length);
    y_train=data_train(:,size(data_train,2));
    X_test=X1(14001:20000,1:length);
    y_test=label(14001:20000,:);
    
    load('newdata_test_20.mat');
    Data=Data(:,1:length/2);
    [m,n]=size(Data);
    X1=zeros(m,2*n);
    for i=1:m
        for j=1:n
           X1(i,2*j-1)=real(Data(i,j));
           X1(i,2*j)=imag(Data(i,j));
%            X1(i,2*j-1)=abs(Data(i,j));
%            X1(i,2*j)=angle(Data(i,j));
        end
    end
    X_test_=X1;
    y_test_=label;
end