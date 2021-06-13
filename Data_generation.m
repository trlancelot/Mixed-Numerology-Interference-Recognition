clear;close all;clc;
%----------------------------- ofdm调制———————————————————
parameters1 = [];                      % Clear Parameters variable
parameters1.NDLRB = 100;               % Bandwidth in number of resource blocks
parameters1.SubcarrierSpacing=15;      % 15, 30, 60, 120, 240, 480 (kHz)
parameters1.CyclicPrefix = 'Normal';   % 'Normal' or 'Extended'
parameters1.NTxAnts = 1;               % Number of PDSCH transmission antennas
parameters1.NRxAnts = 1;               % Number of UE receive antennas
parameters1.M = 64;                    % MQAM OR QPSK
parameters1.modulatetype='QAM';

parameters2 = [];                      % Clear Parameters variable
parameters2.NDLRB = 50;                % Bandwidth in number of resource blocks 
parameters2.SubcarrierSpacing=30;      % 15, 30, 60, 120, 240, 480 (kHz)
parameters2.CyclicPrefix = 'Normal';   % 'Normal' or 'Extended'
parameters2.NTxAnts = 1;               % Number of PDSCH transmission antennas
parameters2.NRxAnts = 1;               % Number of UE receive antennas 
parameters2.M = 64;                    % MQAM OR QPSK
parameters2.modulatetype='QAM'; 

% [ofdmwaveform1] = OFDMModulate(parameters1);
% [ofdmwaveform2] = OFDMModulate(parameters2);
% fs_=61.44e6;fbb=10e6;
% [b,a]=cheby1(3,1,2*fbb/fs_);
% [d,c]=cheby1(7,1,2*fbb/fs_,'high');
% X=zeros(20000,1000);
% y=zeros(20000,1);
% for i=1:20000
%     if(mod(i,2))
%        [ofdmwaveform] = OFDMModulate(parameters1);
%        y(i)=1;
%     else
%        [ofdmwaveform] = OFDMModulate(parameters2);
%     end
%     X(i,:)=ofdmwaveform(1:1000);
% end
% save('data_1','X','y');
% ———————————两信号重采样，频谱搬移，合成——————————————
% ofdmwaveform2re=resample(ofdmwaveform2,2,1);
% ofdmwaveform1re=resample(ofdmwaveform1,2,1);
% fs=30.72;dt=1/fs;
% N=length(ofdmwaveform2re);
% n=1:N;l=1:N/2;
% figure(1);
% stem(n*6144/N,abs(fft(ofdmwaveform2re,N)));title('原信号');
% ex=exp(1i*2*pi*20*n'*dt/2);
% ofdmwaveform2shift=ofdmwaveform2re.*ex;
% figure(2);
% stem(n*6144/N,abs(fft(ofdmwaveform2shift,N)));title('频谱搬移');
% txwaveform=ofdmwaveform1re+ofdmwaveform2shift; 
% figure(3);
% stem(n*6144/N,abs(fft(txwaveform,N)));title('两信号相加');
%———————————————加性高斯白噪声信道———————————————
% % rxwave=awgn(txwaveform,15,'measured');
% % figure(4);
% % stem(n*6144/N,abs(fft(rxwave,N)));title('awgn接收信号频谱');
%————————————————cdl(tdl)信道—————————————————
% rxwave=cdlchannel(txwaveform);
% figure(4);
% stem(n*6144/N,abs(fft(rxwave,N)));title('cdl接收信号频谱');
%——————————————过滤高频，重采样—————————————————
% figure(7);
% freqz(b,a);
% % rxwavefir=filter(b,a,rxwave);
% % rxwavefir=filter(d,c,rxwavefir);
% % rxwavefir=fir(rxwave);
% figure(5);
% stem(n*6144/N,abs(fft(rxwavefir,N)));title('过滤掉高频');
% rxwaveform=resample(rxwavefir,1,2);
% % hn=[-0.0021,0.0058,-0.0059,-0.0018,0.0145,-0.0202,0.0065,0.0249,-0.0511,0.0381,0.0336,-0.1474,0.2532,0.7036,0.2532,-0.1474,0.0336,0.0381,-0.0511,0.0249,0.0065,-0.0202,0.0145,-0.0018,-0.0059,0.0058,-0.0021];
% figure(6);
% subplot(2,1,1);
% stem(l*3072*2/N,abs(fft(rxwaveform,N/2)));title('最终接收信号');
% subplot(2,1,2);
% stem(l*3072*2/N,abs(fft(ofdmwaveform1,N/2)));title('最初发生信号');
% ———————————————循环产生数据——————————————————
NUM=2000;fs=30.72;dt=1/fs;
fs_=61.44e6;fbb=10e6;
[b,a]=cheby1(3,1,2*fbb/fs_);
label=zeros(NUM,1);
Data=zeros(NUM,359);
n=1:4416; l=666:1024;
ex=exp(1j*2*pi*19*n'*dt/2);
SNR=25;
noise=wgn(4416,1,-SNR,'complex');
hn=[-0.0021,0.0058,-0.0059,-0.0018,0.0145,-0.0202,0.0065,0.0249,-0.0511,0.0381,0.0336,-0.1474,0.2532,...
    0.7036,0.2532,-0.1474,0.0336,0.0381,-0.0511,0.0249,0.0065,-0.0202,0.0145,-0.0018,-0.0059,0.0058,-0.0021];
for i=1:NUM
   [ofdmwaveform1] = OFDMModulate(parameters1);
   if(mod(i,2))
       [ofdmwaveform2] = OFDMModulate(parameters2);
       label(i)=1;
   else
       [ofdmwaveform2] = OFDMModulate(parameters1);
   end
%    ofdmwaveform1(1)
%    ofdmwaveform1(2)
   ofdmwaveform1re=resample(ofdmwaveform1,2,1);
   ofdmwaveform2re=resample(ofdmwaveform2,2,1);
   ofdmwaveform2shift=ofdmwaveform2re.*ex;
   txwaveform=ofdmwaveform1re+ofdmwaveform2shift;
   
   sigPower = sum(abs(txwaveform(:)).^2)/numel(txwaveform);
   txwaveform=txwaveform/sqrt(sigPower);
%    figure(1);
%    stem(n*6144/4416,abs(fft(txwaveform,4416)));
%    xlabel('频率(x10^4 hz)');ylabel('幅度');
% %    sigPower = sum(abs(txwaveform(:)).^2)/numel(txwaveform);
% %    noisePower=10*log10(sigPower)-SNR;
%     [x,y]=size(txwaveform);
%    rxwave=txwaveform+noise;
% %    rxwave=awgn(txwaveform,-30,'measured');
% %    rxwave=rxwave-txwaveform;
   rayleigh_chan=rayleigh_channel;
%    SNR = 30;
%    SNR=randi([-10,30]);
%    txwaveform=awgn(txwaveform,SNR,'measured');
%    noise=wgn(4416,1,-SNR,'complex');
   rxwave=filter(rayleigh_chan,txwaveform)+noise; 
%    rxwave=awgn(rxwave,SNR,'measured');
%    sigPower = sum(abs(rxwave(:)).^2)/numel(rxwave);
%    rxwave=rxwave/sqrt(sigPower);
%    figure(2);
%    stem(n*6144/4416,abs(fft(rxwave,4416)));
   rxwavefir=filter(b,a,rxwave);
   rxwaveform=resample(rxwavefir,1,2);
   rxwaveform=conv(rxwaveform,hn);
   rxwaveform=fft(rxwaveform,2048);
%    figure(3);
%    stem((1:2048)*3072/2048,abs(rxwaveform));
% sigPower = sum(abs(rxwaveform(:)).^2)/numel(rxwaveform);
   Data(i,:)=rxwaveform(666:1024);
%    sigPower1=sum(abs(Data(i,:)).^2)/numel(Data(i,:))
%    figure(3);
%    stem(l*3072/2048,abs(rxwaveform(666:1024)));
   fprintf('当前是第%d次循环,请等待............\n',i);
end
save('cnn_test_data_25.mat','Data','label');