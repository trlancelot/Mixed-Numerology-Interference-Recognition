function [rayleigh_chan]=rayleigh_channel
    systemCfg.Carrier_Freq=2e9;
    systemCfg.SamplingRate=61.44e6;
    rng(sum(100*clock));
    channelCfg.Num_paths=randi([1,30]);%6
    maxdelay=15;%15
%     rng(100002);%100002
    randomchan=rand(channelCfg.Num_paths,4);
    tau=floor(sort(randomchan(:,1))*maxdelay);
    tau=(tau-tau(1))*2.7e-9;
    [firstval,powind]=max(randomchan(:,2));
    pdb=randomchan(:,2);
    pdb(powind)=pdb(1);
    tmp1=firstval;
    pdb(1)=firstval;

    pdb=floor(10.^(pdb));
    for l=1:channelCfg.Num_paths-1
        if l>5
            compval=4;
        else
            compval=l;
        end
        pdb(l+1)=pdb(l+1)-compval;
    end
    pdb=pdb-pdb(1);
    theda=sort(randomchan(:,3))*pi;
    Beda=sort(randomchan(:,4))*pi;
    channelCfg.tau=tau';
    channelCfg.pdb=pdb';
    channelCfg.theda=Beda';
    channelCfg.Beda=theda';

    channelCfg.lambda=3*10^8/systemCfg.Carrier_Freq;
    channelCfg.d=(channelCfg.lambda)/2;
    pdb=10.^(channelCfg.pdb/10);
    channelCfg.linearpdb=pdb/sum(pdb);
    temp=0:channelCfg.Num_paths-1;
    temp=temp+15;
    temp(1)=0;
    channelCfg.delay=temp;
    fc=systemCfg.Carrier_Freq;
    v=0.01;
    fd=v*fc/3e8;
    channelCfg.fd=fd;

    channelCfg.chan=rayleighchan(1/systemCfg.SamplingRate,fd,channelCfg.tau,channelCfg.pdb);
    channelCfg.chan.StoreHistory=1;
%     channelCfg.chan
    channelCfg.chan.ResetBeforeFiltering=0;
%     legacychannelsim(true);
    rayleigh_chan=channelCfg.chan;
%     reset(channelCfg.chan,randseedChanReset);
end