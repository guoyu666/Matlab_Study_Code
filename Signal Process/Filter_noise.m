%% 从信号中去除不需要的频谱内容
% 滤波器通常用于从信号中去除不需要的频谱内容。您可以从各种滤波器中进行选择来实现以上目的。
% 当您要去除高频成分时，可以选择低通滤波器；或者当您要去除低频成分时，可以选择高通滤波器。
% 您也可以选择带通滤波器来去除低频和高频成分，同时保持中间频带不变。当您要去除给定频带上的频率时，可以选择带阻滤波器。
% 假设存在一个包含电力线嗡嗡声和白噪声的音频信号。电力线嗡嗡声是由 60 Hz 的音调引起的。白噪声是一种存在于所有音频带宽中的信号。
% 加载该音频信号。指定 44.1 kHz 的采样率。

Fs = 44100; % 设定采样率的大小
y = audioread('noisymusic.wav'); % 读取音频信号

% 绘制该信号的功率谱。红色三角形标记显示干扰音频信号的强 60 Hz 音调
[P,F] = pwelch(y,ones(8192,1),8192/2,8192,Fs,'power');
helperFilterIntroductionPlot1(F,P,[60 60],[-9.365 -9.365],...
  {'Original signal power spectrum', '60 Hz Tone'})

% 您可以先使用低通滤波器去除尽可能多的白噪声频谱内容。对滤波器的通带设置的值应在降低噪声和因高频成分损失而导致的音频降级之间提供良好的平衡。在去除 60 Hz 的杂声之前应用低通滤波器是非常方便的，因为您将能够对频带受限的信号进行下采样。
% 较低的速率信号将允许您用较小的滤波器阶数设计更尖锐和更窄的 60 Hz 带阻滤波器。
% 设计一个通带频率为 1 kHz、阻带频率为 1.4 kHz 的低通滤波器。选择一个最小阶设计。
Fp = 1e3;    % Passband frequency in Hz
Fst = 1.4e3; % Stopband frequency in Hz
Ap = 1;      % Passband ripple in dB
Ast = 95;    % Stopband attenuation in dB

df = designfilt('lowpassfir','PassbandFrequency',Fp,...
                'StopbandFrequency',Fst,'PassbandRipple',Ap,...
                'StopbandAttenuation',Ast,'SampleRate',Fs);

fvtool(df,'Fs',Fs,'FrequencyScale','log',...
  'FrequencyRange','Specify freq. vector','FrequencyVector',F)

% 对数据进行滤波并补偿延迟
D = mean(grpdelay(df)); % Filter delay平均值
ylp = filter(df,[y; zeros(D,1)]);
ylp = ylp(D+1:end);

% 查看经过低通滤波的信号的频谱。1400 Hz 以上的频率成分已去除。
[Plp,Flp] = pwelch(ylp,ones(8192,1),8192/2,8192,Fs,'power');
helperFilterIntroductionPlot1(F,P,Flp,Plp,...
  {'Original signal','Lowpass filtered signal'})

% 从上面的功率谱图中，您可以看到经过低通滤波的信号的最大不可忽略频率成分为 1400 Hz。根据采样定理，采样率为 2×1400=2800 Hz 就足以正确表示信号，但您使用的采样率为 44100 Hz，这会浪费资源，因为您需要处理不必要的采样。您可以对信号进行下采样以降低采样率，并通过减少需要处理的采样数来减轻计算负载。
% 较低的采样率还允许您设计更尖锐、更窄的带阻滤波器，以较小的滤波器阶数去除 60 Hz 噪声。
% 按因子 10 对低通滤波信号进行下采样，以获得 Fs/10 = 4.41 kHz 采样率。绘制下采样之前与之后的信号频谱。
Fs = Fs/10;
yds = downsample(ylp,10);

[Pds,Fds] = pwelch(yds,ones(8192,1),8192/2,8192,Fs,'power');
helperFilterIntroductionPlot1(F,P,Fds,Pds,...
  {'Signal sampled at 44100 Hz', 'Downsampled signal, Fs = 4410 Hz'})

% 现在使用一个 IIR 带阻滤波器去除 60 Hz 音调。将阻带宽度设置为 4 Hz，以 60 Hz 为中心。选
% 择一个 IIR 滤波器，以实现尖锐频率陷波、小通带波纹和相对较低的阶数。
df = designfilt('bandstopiir','PassbandFrequency1',55,...
               'StopbandFrequency1',58,'StopbandFrequency2',62,...
               'PassbandFrequency2',65,'PassbandRipple1',1,...
               'StopbandAttenuation',60,'PassbandRipple2',1,...
               'SampleRate',Fs,'DesignMethod','ellip');         
% 分析幅值响应
fvtool(df,'Fs',Fs,'FrequencyScale','log',...
  'FrequencyRange','Specify freq. vector','FrequencyVector',Fds(Fds>F(2)))

% 执行零相位滤波以避免相位失真。使用 filtfilt 函数处理数据。
ybs = filtfilt(df,yds);

% 最后，对信号进行上采样，使其回到 44.1 kHz 的原始音频采样率，该采样率与音频声卡兼容。
yf = interp(ybs,10);
Fs = Fs*10;

% 最后查看原始信号和经过处理的信号的频谱。高频本底噪声和 60 Hz 音调已被滤波器衰减。
[Pfinal,Ffinal] = pwelch(yf,ones(8192,1),8192/2,8192,Fs,'power');
helperFilterIntroductionPlot1(F,P,Ffinal,Pfinal,...
  {'Original signal','Final filtered signal'})