function [ofdmwaveform] = OFDMModulate(parameters)
    Parameters = [];                      % Clear Parameters variable
    Parameters.NDLRB = parameters.NDLRB;                            % Bandwidth in number of resource blocks (51RBs at 30kHz SCS for 20MHz BW)
    Parameters.SubcarrierSpacing =parameters.SubcarrierSpacing ;    % 15, 30, 60, 120, 240, 480 (kHz)
    Parameters.CyclicPrefix = parameters.CyclicPrefix;     % 'Normal' or 'Extended'
    Parameters.NTxAnts = parameters.NTxAnts;               % Number of PDSCH transmission antennas
    Parameters.NRxAnts = parameters.NRxAnts;               % Number of UE receive antennas
    info = hOFDMInfo(Parameters);
    M=parameters.M;
    rng(sum(100*clock));
    if (parameters.modulatetype=='QAM')
        inSig=randi([0 M-1],info.NSubcarriers,ceil(7200/(info.NSubcarriers*log2(M))));
        out=qammod(inSig,M,'gray');
    end
    if (parameters.modulatetype=='PSK')
        inSig=randi([0 M-1],info.NSubcarriers,ceil(14400/(info.NSubcarriers*log2(M))));
        out=pskmod(inSig,M,pi/M,'gray');
    end
    [WAVEFORM,INFO] = hOFDMModulate(Parameters,out);
    INFO
    ofdmwaveform=WAVEFORM;
%     OFDMDeout= hOFDMDemodulate(Parameters,WAVEFORM);
%     outSig=qamdemod(OFDMDeout,M,'gray');
%     equal=isequal(outSig,inSig)
end