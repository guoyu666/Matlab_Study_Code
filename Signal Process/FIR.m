%% 最小阶 FIR 设计(有限冲击响应滤波器)
%设计最小阶低通 FIR 滤波器，其通带频率为 0.37*pi 弧度/采样点，阻带频率为 0.43*pi 弧度/采样点
% （因此过渡带宽度等于 0.06*pi 弧度/采样点），通带波纹为 1 dB，阻带衰减为 30 dB
Fpass = 0.37;
Fstop = 0.43;
Ap = 1;
Ast = 30;

d = designfilt('lowpassfir', 'PassbandFrequency', Fpass,...
    'StopbandFrequency', Fstop, 'PassbandRipple', Ap, 'StopbandAttenuation', Ast);
% 默认情况下，designfilt 函数会选择一个等波纹设计算法。
% 线性相位等波纹滤波器是令人满意的，因为对于给定阶数，这种滤波器与理想滤波器的最大可能偏差最小。

hfvt = fvtool(d);
N = filtord(d)  %滤波器的阶数
%% 
% 也可以使用凯塞窗获得最小阶设计。即使凯塞窗方法对相同设定产生更大的滤波器阶数，
% 当设计设定非常严格时，该算法的计算成本更低，并且不太可能出现收敛问题
Fpass = 0.37;
Fstop = 0.43;
Ap = 1;
Ast = 30;

d = designfilt('lowpassfir', 'PassbandFrequency', Fpass,...
    'StopbandFrequency', Fstop, 'PassbandRipple', Ap, 'StopbandAttenuation', Ast);

hfvt = fvtool(d);

dk = designfilt('lowpassfir','PassbandFrequency',Fpass,...
  'StopbandFrequency',Fstop,'PassbandRipple',Ap,...
  'StopbandAttenuation',Ast, 'DesignMethod', 'kaiserwin');

addfilter(hfvt,dk);
legend(hfvt,'Equiripple design', 'Kaiser window design')
N = filtord(dk) %滤波器阶数
%% 以赫兹为单位指定频率参数
%如果知道滤波器工作将使用的采样率，可以指定采样率和频率（以赫兹为单位）。重新设计采样率为 2 kHz 的最小阶等波纹滤波器。
Fpass = 370;
Fstop = 430;
Ap = 1;
Ast = 30;
Fs = 2000; %采样率

d = designfilt('lowpassfir','PassbandFrequency',Fpass,...
  'StopbandFrequency',Fstop,'PassbandRipple',Ap,...
  'StopbandAttenuation',Ast,'SampleRate',Fs);
  
hfvt = fvtool(d);
%% 固定阶、固定过渡带宽度
% 固定阶设计适用于对计算负载敏感或对滤波器系数个数有限制的应用。一种选择是以控制通带波纹/阻带衰减为代价来固定过渡带宽度。
% 假设一个 30 阶低通 FIR 滤波器，其通带频率为 370 Hz，阻带频率为 430 Hz，采样率为 2 kHz。对于这组特定设定，可使用两种设计方法：
% 等波纹法和最小二乘法。下面我们为每种方法设计一个滤波器，并比较结果。
N = 30;
Fpass = 370;
Fstop = 430;
Fs = 2000; 

% Design method defaults to 'equiripple' when omitted(等波纹设计法)
deq = designfilt('lowpassfir','FilterOrder',N,'PassbandFrequency',Fpass,...
  'StopbandFrequency',Fstop,'SampleRate',Fs);

%最小二乘法
dls = designfilt('lowpassfir','FilterOrder',N,'PassbandFrequency',Fpass,...
  'StopbandFrequency',Fstop,'SampleRate',Fs,'DesignMethod','ls');

hfvt = fvtool(deq,dls);
legend(hfvt,'Equiripple design等波纹设计法', 'Least-squares design最小二乘法')
%%
%在上述示例中，设计的滤波器在通带和阻带中具有相同的波纹。我们可以使用权重来减少其中一个频带内的波纹，同时保持滤波器阶数固定。
% 例如，如果您希望阻带波纹是通带波纹的十分之一，则为阻带赋予的权重必须是通带权重的十倍。根据上述情况重新设计等波纹滤波器。
N = 30;
Fpass = 370;
Fstop = 430;
Fs = 2000; 

% Design method defaults to 'equiripple' when omitted
deq = designfilt('lowpassfir','FilterOrder',N,'PassbandFrequency',Fpass,...
  'StopbandFrequency',Fstop,'SampleRate',Fs);
deqw = designfilt('lowpassfir','FilterOrder',N,'PassbandFrequency',Fpass,...
  'StopbandFrequency',Fstop,'SampleRate',Fs,...
  'PassbandWeight',1,'StopbandWeight',10);

hfvt = fvtool(deq,deqw);
legend(hfvt,'Equiripple design', 'Equiripple design with weighted stopband')
%% 固定阶、固定截止频率
%例如，假设有截止频率为 60 Hz、采样率为 1 kHz 的 100 阶低通 FIR 滤波器。比较使用汉明窗和使用旁瓣衰减为 90 dB 的切比雪夫窗产生的设计。
dhamming = designfilt('lowpassfir','FilterOrder',100,'CutoffFrequency',60,...
  'SampleRate',1000,'Window','hamming');

dchebwin = designfilt('lowpassfir','FilterOrder',100,'CutoffFrequency',60,...
  'SampleRate',1000,'Window',{'chebwin',90});

hfvt = fvtool(dhamming,dchebwin);
legend(hfvt,'Hamming window', 'Chebyshev window')
