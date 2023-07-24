%% Fvtool-设计低通等波纹 FIR 滤波器。
% 我们希望创建一个低通滤波器，其通带频率为 0.4π 弧度/采样点、阻带频率为 0.6π 弧度/采样点、通带波纹为 1 dB、阻带衰减为 80 dB。
% 我们使用 Signal Processing Toolbox 的一些滤波器设计工具来设计滤波器，然后在 FVTool 中分析结果。

Df1 = designfilt("lowpassfir",PassbandFrequency=0.4,...
                              StopbandFrequency=0.6,...
                              PassbandRipple=1,...
                              StopbandAttenuation=80,...
                              DesignMethod="equiripple");

% 设计低通椭圆 IIR 滤波器。
Df2 = designfilt("lowpassiir",PassbandFrequency=0.4,...
                              StopbandFrequency=0.6,...
                              PassbandRipple=1,...
                              StopbandAttenuation=80,...
                              DesignMethod="ellip");
hfvt = fvtool(Df1,Df2)

% 添加滤波器
Df3 = designfilt("lowpassiir",PassbandFrequency=0.4,...
                              StopbandFrequency=0.6,...
                              PassbandRipple=1,...
                              StopbandAttenuation=80,...
                              DesignMethod="cheby2");

addfilter(hfvt,Df3);
legend(hfvt, 'equiripple', 'ellip', 'cheby2')

% 您可以使用 deletefilter 函数并传递要删除的滤波器的索引，从 FVTool 中删除滤波器
deletefilter(hfvt,[1 3])

hfvt.MagnitudeDisplay = "Magnitude Squared";
hfvt.Analysis = "grpdelay";

% 重叠两个分析
set(hfvt,OverlayedAnalysis="magnitude", Legend="On")