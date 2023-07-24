%% 使用频率分析求周期性
% 通常很难通过观察时间测量值来表征数据中的振荡行为。频谱分析有助于确定信号是否为周期性信号并测量不同周期。
% 办公楼内的温度计每半小时测量一次室内温度，持续四个月。加载数据并对其绘图。将温度转换为摄氏度。
% 测量时间以周为单位。因此，采样率为 2 次测量/小时 × 24 小时/天 × 7 天/周 = 336 次测量/周
load("officetemp.mat")

tempC = (temp - 32)*5/9;    % 温度转化

fs = 2*24*7;
t = (0:length(tempC) - 1)/fs;%  归一化，统一转化成以周为计数单位

subplot(2,1,1)
plot(t,tempC)
xlabel('Time (weeks)')
ylabel('Temperature ( {}^\circC )')
axis tight

% 温度似乎确实有震荡特性，但周期的长度并不容易确定。此时，看看信号的频率成分。
% 减去均值以重点关注温度波动。计算并绘制周期图。
tempnorm = tempC - mean(tempC);

[pxx,f] = periodogram(tempnorm,[],[],fs);   % pxx代表返回周期图功率谱密度的估计，f代表每单位时间的周期

subplot(2,1,2)
plot(f,pxx)
ax = gca;
ax.XLim = [0 10];
xlabel('Frequency (cycles/week)')
ylabel('Magnitude')
%% 使用自相关求周期性
load officetemp

tempC = (temp-32)*5/9;

tempnorm = tempC-mean(tempC);

fs = 2*24;
t = (0:length(tempnorm) - 1)/fs;    % 归一化，统一转化成以天为计数单位

subplot(2,1,1)
plot(t,tempnorm)
xlabel('Time (days)')
ylabel('Temperature ( {}^\circC )')
axis tight

% 温度似乎确实有震荡特性，但周期的长度并不容易确定。
% 计算温度的自相关性（时滞为零时该值为 1）。将正时滞和负时滞限制为三周。请注意信号的双周期性。
[autocor,lags] = xcorr(tempnorm,3*7*fs,'coeff');

subplot(2,1,2)
plot(lags/fs,autocor)
hold on
xlabel('Lag (days)')
ylabel('Autocorrelation')
axis([-21 21 -0.4 1.1])



% 通过找到峰值位置并确定它们之间的平均时间差来确定短周期和长周期。
% 要找到长周期，请将 findpeaks 限制为只寻找间隔时间超过短周期且最小高度为 0.3 的峰值。
[pksh,lcsh] = findpeaks(autocor);
short = mean(diff(lcsh))/fs

[pklg,lclg] = findpeaks(autocor, ...
    'MinPeakDistance',ceil(short)*fs,'MinPeakheight',0.3);
long = mean(diff(lclg))/fs

pks = plot(lags(lcsh)/fs,pksh,'or', ...
    lags(lclg)/fs,pklg+0.05,'vk');
hold off
legend(pks,[repmat('Period: ',[2 1]) num2str([short;long],0)])
axis([-21 21 -0.4 1.1])