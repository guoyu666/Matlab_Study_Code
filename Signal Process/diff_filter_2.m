%% 取信号的导数
% 您要在不增加噪声功率的情况下对信号求导。MATLAB® 提供的函数 diff 会放大噪声，对于高阶导数会恶化不精确性。要解决此问题，请改用微分滤波器。
% 分析地震时建筑物楼层的位移。找到速度和加速度作为时间的函数。

% drift:楼层位移，以厘米为单位进行测量
% t:时间，以秒为单位进行测量
% Fs:采样率，等于 1 kHz

load('earthquake.mat')

% 使用 pwelch 显示信号功率谱的估计值。请注意大部分信号能量包含在低于 100 Hz 的频率中。
pwelch(drift, [], [], [], Fs)

% 使用 designfilt 设计一个阶数为 50 的 FIR 微分器。要包含大部分信号能量，请指定 100 Hz 的通带频率和 120 Hz 的阻带频率。
% 使用 fvtool 检查滤波器。
Nf = 50; 
Fpass = 100; 
Fstop = 120;

d = designfilt('differentiatorfir','FilterOrder',Nf, ...
    'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
    'SampleRate',Fs);

fvtool(d,'MagnitudeDisplay','zero-phase','Fs',Fs)

% 对漂移求导以求出速度。将导数除以 dt（即连续采样之间的时间间隔），以设置正确的单位。
dt = t(2)-t(1);
vdrift = filter(d,drift)/dt;

% 滤波后的信号存在延迟。使用 grpdelay 确定延迟是滤波器阶数的一半。通过丢弃采样对此进行补偿。
delay = mean(grpdelay(d))
tt = t(1:end-delay);
vd = vdrift;
vd(1:delay) = [];

% 对漂移和漂移速度绘图。使用 findpeaks 验证漂移的最大值和最小值对应于其导数的过零点。
[pkp,lcp] = findpeaks(drift);
zcp = zeros(size(lcp));

[pkm,lcm] = findpeaks(-drift);
zcm = zeros(size(lcm));

subplot(2,1,1)
plot(t,drift,t([lcp lcm]),[pkp -pkm],'or')
xlabel('Time (s)')
ylabel('Displacement (cm)')
grid

subplot(2,1,2)
plot(tt,vd,t([lcp lcm]),[zcp zcm],'or')
xlabel('Time (s)')
ylabel('Speed (cm/s)')
grid

