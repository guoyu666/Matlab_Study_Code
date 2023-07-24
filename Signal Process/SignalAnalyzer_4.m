%% 低通 FIR 滤波器 - 加窗方法
% 此示例说明如何使用两个命令行函数 fir1 和 designfilt 以及交互式滤波器设计工具来设计和实现 FIR 滤波器。
% 创建要在示例中使用的信号。该信号是 N(0,1/4) 加性高斯白噪声中的 100 Hz 正弦波。将随机数生成器设置为默认状态，以获得可重现的结果。
rng default

Fs = 1000;
t = linspace(0,1,Fs);
x = cos(2*pi*100*t)+0.5*randn(size(t));

% 要设计的滤波器是阶数等于 20、截止频率为 150 Hz 的 FIR 低通滤波器。
% 使用凯塞窗，其长度比滤波器阶和 β=3 多一个样本。有关凯塞窗的详细信息，请参阅 kaiser。
% 使用 fir1 设计滤波器。fir1 需要区间 [0, 1] 内的归一化频率，其中 1 对应于 π 弧度/采样点。
% 要使用 fir1，您必须将所有频率设定转换为归一化频率。
% 设计滤波器并查看幅值响应。
fc = 150;
Wn = (2/Fs)*fc;
b = fir1(20,Wn,'low',kaiser(21,3));

[h,f] = freqz(b,1,[],Fs);
plot(f,mag2db(abs(h)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
grid

% 将滤波器应用于信号，并绘制 100 Hz 正弦波的前十个周期的结果。
y = filter(b,1,x);

plot(t,x,t,y)
xlim([0 0.1])

xlabel('Time (s)')
ylabel('Amplitude')
legend('Original Signal','Filtered Data')
%% 使用 designfilt 设计相同的滤波器。将滤波器响应设置为 'lowpassfir'，并以 Name,Value 对组形式输入设定。使用 designfilt 时，您可以以 Hz 为单位指定滤波器设计
Fs = 1000;
t = linspace(0,1,Fs);
x = cos(2*pi*100*t)+0.5*randn(size(t));
Hd = designfilt('lowpassfir','FilterOrder',20,'CutoffFrequency',150, ...
       'DesignMethod','window','Window',{@kaiser,3},'SampleRate',Fs);

% 对数据进行滤波并绘制结果。
y1 = filter(Hd,x);

plot(t,x,t,y1)
xlim([0 0.1])

xlabel('Time (s)')
ylabel('Amplitude')
legend('Original Signal','Filtered Data')
%% 使用滤波器设计工具App
Fs = 1000;
t = linspace(0,1,Fs);
x = cos(2*pi*100*t)+0.5*randn(size(t));
y2 = filter(Hd_filter,x);

plot(t,x,t,y2)
xlim([0 0.1])

xlabel('Time (s)')
ylabel('Amplitude')
legend('Original Signal','Filtered Data')