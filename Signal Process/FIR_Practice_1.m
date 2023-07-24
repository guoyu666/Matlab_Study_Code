%补偿常量滤波器延迟如前所述，您可以测量滤波器的群延迟，以验证它是频率的常量函数。
% 您可以使用 grpdelay 函数来测量滤波器延迟 D，并通过在输入信号中追加 D 个零并按时间将输出信号偏移 D 个采样来补偿此延迟。
%假设您要对含噪心电图信号进行滤波，以去除 75 Hz 以上的高频噪声。您要应用一个 FIR 低通滤波器并补偿滤波器延迟，以便含噪信号和经过滤波的信号正确对齐，并可以叠加绘图进行比较。

Fs = 500;                     % Sample rate in Hz
N  = 500;                     % Number of signal samples
rng default;                  %控制随机数生成器 
x = ecg(N)' + 0.25*randn(N,1); % Noisy waveform其中'代表转置
t = (0:N-1)/Fs;               % Time vector
    
Fnorm = 75/(Fs/2);            % Normalized frequency归一化频率
df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm); %设计一个截止频率为 75 Hz 的 70 阶低通 FIR 滤波器。

grpdelay(df,2048,Fs)          % Plot group delaygr
D = mean(grpdelay(df))        % Filter delay in samples平均值
%%
%在滤波前，在输入数据向量 x 的末尾追加 D 个零。这可以确保所有有用的采样都通过滤波器，并且输入信号和经过延迟补偿的输出信号具有相同的长度。
%对数据进行滤波，并通过将输出信号偏移 D 个采样来补偿延迟。最后一步有效地消除了滤波器瞬变。
Fs = 500;                        % Sample rate in Hz
N  = 500;                        % Number of signal samples
rng default;                     %控制随机数生成器 
x = ecg(N)' + 0.25*randn(N,1);   % Noisy waveform其中'代表转置
t = (0:N-1)/Fs;                  % Time vector

y = filter(df,[x; zeros(D,1)]);  % Append D zeros to the input data
y = y(D+1:end);                  % Shift data to compensate for delay

plot(t,x,t,y,'linewidth',1.5)    %同时显示原始的信号和进行时延补偿后的信号
title('Filtered Waveforms')
xlabel('Time (s)')
legend('Original Noisy Signal','Filtered Signal')
grid on
axis tight
%%
% 补偿与频率有关的延迟
% 与频率有关的延迟会导致信号相位失真。补偿这种类型的延迟并不像常量延迟那样无关紧要。
% 如果您的应用允许离线处理，您可以通过使用 filtfilt 函数实现零相位滤波来消除与频率有关的延迟。
% filtfilt 通过正向和反向处理输入数据来执行零相位滤波。主效应是获得零相位失真，即使用常时滞为 0 个采样的等效滤波器对数据进行滤波。
% 其他效应是，您得到的滤波器传递函数等于原始滤波器传递函数的平方幅值，并且滤波器阶数是原始滤波器阶数的两倍。

%以上一节中定义的 ECG 信号为例。对此信号进行带延迟补偿和不带延迟补偿的滤波。设计一个截止频率为 75 Hz 的 7 阶低通 IIR 椭圆滤波器。
Fs = 500;                     % Sample rate in Hz
N  = 500;                     % Number of signal samples
rng default;                  %控制随机数生成器 
x = ecg(N)' + 0.25*randn(N,1);% Noisy waveform其中'代表转置
t = (0:N-1)/Fs;               % Time vector
Fnorm = 75/(Fs/2);            % Normalized frequency
df = designfilt('lowpassiir',...
               'PassbandFrequency',Fnorm,...
               'FilterOrder',7,...
               'PassbandRipple',1,...
               'StopbandAttenuation',60);

grpdelay(df,2048,'half',Fs)

%对数据进行滤波，并观察每个滤波器实现对时间信号的影响。零相位滤波有效地消除了滤波器延迟。
y1 = filter(df,x);    % Nonlinear phase filter - no delay compensation
y2 = filtfilt(df,x);  % Zero-phase implementation - delay compensation

plot(t,x)
hold on
plot(t,y1,'r','linewidth',1.5)
plot(t,y2,'linewidth',1.5)
title('Filtered Waveforms')
xlabel('Time (s)')
legend('Original Signal','Non-linear phase IIR output',...
  'Zero-phase IIR output')
xlim([0.25 0.55])
grid on

