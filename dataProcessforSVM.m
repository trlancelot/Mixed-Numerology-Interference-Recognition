function [x_train,y_train,x_test,y_test] = dataProcessforSVM
    length=250;
    load('newdata2.mat');
    Data=Data(:,1:length);
    [m,~]=size(Data);
    data=zeros(m,2*length);
    X=zeros(1,2*length);
    for i=1:m
       for j=1:length
          X(1,j)=real(Data(i,j));
          X(1,j+length)=imag(Data(i,j));
%           X(1,j)=abs(Data(i,j));
%           X(1,j+length)=angle(Data(i,j));
       end
       data(i,:)=X;
    end
    data_train=[data,label];
    rng(sum(100*clock));
    rowrank=randperm(size(data_train,1));
    data_train=data_train(rowrank,:);
    
    x_train=data_train(:,1:2*length);
    y_train=categorical(data_train(:,size(data_train,2)));
%     y_train=data_train(:,size(data_train,2));
    
    load('newdata2_test_0.mat');
    Data=Data(:,1:length);
    [m,~]=size(Data);
    data=zeros(m,2*length);
    X=zeros(1,2*length);
    for i=1:m
       for j=1:length
          X(1,j)=real(Data(i,j));
          X(1,j+length)=imag(Data(i,j));
%           X(1,j)=abs(Data(i,j));
%           X(1,j+length)=angle(Data(i,j));
       end
       data(i,:)=X;
    end
    x_test=data;
    y_test=categorical(label);
end

