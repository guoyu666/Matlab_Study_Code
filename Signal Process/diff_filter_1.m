%% 对信号求微分
% MATLAB diff 函数能够对信号求微分，但其缺点是可能增加输出的噪声级别。
% 更好的选择是使用微分滤波器，它在感兴趣的频带中充当微分器，在所有其他频率上充当衰减器，从而有效地去除高频噪声。
% 下面通过示例来分析地震过程中建筑物楼层的位移速度。
% 在地震条件下，位移或漂移测量值记录在三层待测建筑物的第一楼层，并保存在 quakedrift.mat 文件中。
% 数据向量的长度为 10e3，采样率为 1 kHz，测量单位为 cm。
% 对位移数据求微分，以获得地震期间建筑物楼层的速度和加速度的估计值。使用 diff 函数和一个 FIR 微分滤波器比较结果。
load quakedrift.mat 

Fs  = 1000;                 % Sample rate
dt = 1/Fs;                  % Time differential
t = (0:length(drift)-1)*dt; % Time vector

% 设计一个 50 阶微分滤波器，通带频率为 100 Hz，这是发现大部分信号能量的带宽。将滤波器的阻带频率设置为 120 Hz。
df = designfilt('differentiatorfir','FilterOrder',50,...
                'PassbandFrequency',100,'StopbandFrequency',120,...
                'SampleRate',Fs);

% diff 函数可被视为一阶 FIR 滤波器，其响应为 H(Z)=1−Z的负1次方
% 使用 FVTool 比较 50 阶 FIR 微分滤波器的幅值响应和 diff 函数的响应。
% 显然，这两种响应在通带区域（从 0 到 100 Hz）是等效的。然而，在阻带区域，50 阶滤波器会衰减分量，而 diff 响应会放大分量。这有效地增大了高频噪声的级别。
hfvt = fvtool(df,[1 -1],1,'MagnitudeDisplay','zero-phase','Fs',Fs);
legend(hfvt,'50th order FIR differentiator','Response of diff function');