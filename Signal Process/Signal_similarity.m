%% 比较具有不同采样率的信号
% 假设有一个音频信号数据库和一个模式匹配应用程序，您需要在歌曲播放时识别该歌曲。数据通常以低采样率存储，以占用较少的内存。
load relatedsig
%%
figure
ax(1) = subplot(3,1,1);
plot((0:numel(T1)-1)/Fs1,T1,"k")    % numel求数组元素的数目。以低采样率存储，以占用较少的内存
ylabel("Template 1")
grid on
ax(2) = subplot(3,1,2); 
plot((0:numel(T2)-1)/Fs2,T2,"r")
ylabel("Template 2")
grid on
ax(3) = subplot(3,1,3); 
plot((0:numel(S)-1)/Fs,S)
ylabel("Signal")
grid on
xlabel("Time (s)")
linkaxes(ax(1:3),"x")
axis([0 1.61 -4 4])
%% 
% 长度不同使您无法计算两个信号之间的差，但这可以通过提取信号的共同部分来轻松解决。此外，并不始终需要对长度进行均衡化处理。
% 不同长度的信号之间可以执行互相关，但必须确保它们具有相同的采样率。最安全的做法是以较低的采样率对信号进行重采样。
% resample 函数在重采样过程中对信号应用一个抗混叠（低通）FIR 滤波器。
[P1,Q1] = rat(Fs/Fs1);          % Rational fraction approximation
[P2,Q2] = rat(Fs/Fs2);          % Rational fraction approximation
T1 = resample(T1,P1,Q1);        % Change sample rate by rational factor
T2 = resample(T2,P2,Q2);        % Change sample rate by rational factor
%% 在测量值中查找信号
[C1,lag1] = xcorr(T1,S);        
[C2,lag2] = xcorr(T2,S);        

figure
ax(1) = subplot(2,1,1); 
plot(lag1/Fs,C1,"k")
ylabel("Amplitude")
grid on
title("Cross-Correlation Between Template 1 and Signal")
ax(2) = subplot(2,1,2); 
plot(lag2/Fs,C2,"r")
ylabel("Amplitude") 
grid on
title("Cross-Correlation Between Template 2 and Signal")
xlabel("Time(s)") 
axis(ax(1:2),[-1.5 1.5 -700 700])







